import React, { useEffect, useState } from 'react';
import { Socket } from 'phoenix';
import "./App.css";

const WS_URL = "ws://localhost:4123/socket";

function App() {
  const [messages, setMessages] = useState([]);


  useEffect(() => {
    const userToken = "TOKEN"; // Retrieve from environment
    const socket = new Socket(WS_URL, { params: { userToken } });
    socket.connect();

    const infoChannel = socket.channel("clients:info", {});

    infoChannel.join()
      .receive("ok", resp => console.log("Joined successfully", resp))
      .receive("error", resp => console.log("Unable to join", resp));

    const processClients = (clients) => Object.entries(clients).map(([id, details]) => ({ id, ...details }));

    const eventHandlers = [
      { event: "clients", handler: payload => setMessages(processClients(payload)) },
      { event: "new_client", handler: payload => setMessages(messages => [...messages, payload]) },
      { event: "client_removed", handler: payload => setMessages(messages => messages.filter(message => message.id !== payload.id)) },
    ];

    eventHandlers.forEach(({ event, handler }) => infoChannel.on(event, handler));

    return () => {
      infoChannel.leave();
      socket.disconnect();
    };
  }, []);

  return (
    <div>
      {messages.map((msg, index) => (
        <p key={index}>{msg.id}</p> // Assuming msg is an object, adjust if it's not
      ))}
    </div>
  );
}

export default App;
