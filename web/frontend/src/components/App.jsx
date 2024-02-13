import React, { useEffect, useState } from "react";
import { Socket } from "phoenix";
import "./App.css";
import Sidebar from "./Sidebar";
import Panel from "./Panel";

const WS_URL = "ws://localhost:4123/socket";

function App() {
  const [clients, setClients] = useState([]);
  const [selectedClientId, setSelectedClientId] = useState(0);

  const processClients = (clients) =>
    Object.entries(clients).map(([id, details]) => ({ id, ...details }));

  const updateClients = (messages, newMessage) => {
    let index = messages.findIndex((m) => m.id === Object.keys(newMessage)[0]);

    if (index === -1) return [...messages];

    return messages.map((msg, idx) =>
      idx === index ? { ...msg, ...processClients(newMessage)[0] } : msg,
    );
  };

  useEffect(() => {
    const userToken = "TOKEN";
    const socket = new Socket(WS_URL, { params: { userToken } });
    socket.connect();

    const infoChannel = socket.channel("clients:info", {});

    infoChannel
      .join()
      .receive("ok", (resp) => console.log("Joined successfully", resp))
      .receive("error", (resp) => console.log("Unable to join", resp));

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
      socket.disconnect();
    };
  }, []);

  useEffect(() => console.log(selectedClientId), [selectedClientId]);

  return (
    <>
      <Sidebar
        clients={clients}
        selectedItemId={selectedClientId}
        onItemSelected={setSelectedClientId}
      ></Sidebar>
      <Panel headerText={clients[selectedClientId]?.id}></Panel>
    </>
  );
}

export default App;
