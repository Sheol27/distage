import React, { useEffect, useState } from 'react';
import { Socket } from 'phoenix';
import "./App.css";

const WS_URL = "ws://localhost:4123/socket";

function App() {
  const [messages, setMessages] = useState([]);

  const processClients = (clients) => Object.entries(clients).map(([id, details]) => ({ id, ...details }));

  const updateMessages = (messages, newMessage) => {
    let index = messages.findIndex(m => m.id === Object.keys(newMessage)[0]);

    if (index === -1) return [...messages];

    return messages.map((msg, idx) => idx === index ? { ...msg, ...processClients(newMessage)[0] } : msg);

  }

  useEffect(() => {
    const userToken = "TOKEN"; // Retrieve from environment
    const socket = new Socket(WS_URL, { params: { userToken } });
    socket.connect();

    const infoChannel = socket.channel("clients:info", {});

    infoChannel.join()
      .receive("ok", resp => console.log("Joined successfully", resp))
      .receive("error", resp => console.log("Unable to join", resp));


    const eventHandlers = [
      { event: "clients", handler: payload => setMessages(processClients(payload)) },
      { event: "new_client", handler: payload => setMessages(messages => [...messages, ...processClients(payload)]) },
      { event: "client_stopped", handler: payload => setMessages(messages => updateMessages(messages, payload)) },

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
        <p key={index}>{msg.id}: {msg.status}</p>
      ))}
    </div>
  );
}

export default App;
