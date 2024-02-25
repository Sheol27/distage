import React, { useEffect, useState, useRef } from "react";
import { Socket } from "phoenix";
import "./App.css";
import Sidebar from "./Sidebar";
import Panel from "./Panel";

const WS_URL = "ws://localhost:4123/socket";

function App() {
  const [clients, setClients] = useState([]);
  const [selectedClientId, setSelectedClientId] = useState(null);
  const [logs, setLogs] = useState([]);
  const socketRef = useRef(null);

  useEffect(() => {
    const userToken = "TOKEN";
    if (!socketRef.current) {
      socketRef.current = new Socket(WS_URL, { params: { userToken } });
      socketRef.current.connect();
    }

    const infoChannel = socketRef.current.channel("clients:info", {});

    infoChannel
      .join()
      .receive("ok", (resp) => console.log("Joined successfully", resp))
      .receive("error", (resp) => console.log("Unable to join", resp));

    const processClients = (clients) =>
      Object.entries(clients).map(([id, details]) => ({ id, ...details }));

    const updateClients = (messages, newMessage) => {
      let index = messages.findIndex(
        (m) => m.id === Object.keys(newMessage)[0],
      );
      if (index === -1) return [...messages];
      return messages.map((msg, idx) =>
        idx === index ? { ...msg, ...processClients(newMessage)[0] } : msg,
      );
    };

    const eventHandlers = [
      {
        event: "clients",
        handler: (payload) => setClients(processClients(payload)),
      },
      {
        event: "new_client",
        handler: (payload) =>
          setClients((messages) => [...messages, ...processClients(payload)]),
      },
      {
        event: "client_stopped",
        handler: (payload) =>
          setClients((messages) => updateClients(messages, payload)),
      },
    ];

    eventHandlers.forEach(({ event, handler }) =>
      infoChannel.on(event, handler),
    );

    return () => {
      infoChannel.leave();
      socketRef.current.disconnect();
      socketRef.current = null;
    };
  }, []);

  useEffect(() => {
    if (clients.length === 0) return;
    const logsChannel = socketRef.current.channel(
      `clients:${clients[selectedClientId].id}`,
      {},
    );

    logsChannel
      .join()
      .receive("ok", (resp) => console.log("Joined logs channel", resp))
      .receive("error", (resp) => console.log("Unable to join", resp));

    const eventHandlers = [
      {
        event: "new_log",
        handler: (payload) => setLogs((logs) => [...logs, payload]),
      },
    ];

    eventHandlers.forEach(({ event, handler }) =>
      logsChannel.on(event, handler),
    );

    return () => {
      logsChannel.leave();
    };
  }, [selectedClientId]);

  const onItemSelected = (id) => {
    setSelectedClientId(id);
  };

  return (
    <>
      <Sidebar
        clients={clients}
        selectedItemId={selectedClientId}
        onItemSelected={onItemSelected}
      ></Sidebar>
      <Panel
        headerText={clients[selectedClientId]?.hostname}
        logs={logs}
      ></Panel>
    </>
  );
}

export default App;
