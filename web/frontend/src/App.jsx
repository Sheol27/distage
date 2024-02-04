import { Socket } from 'phoenix';
import React, { useEffect, useState } from 'react';
import "./App.css";

function App() {

  // TODO: ugly, remove from code
  const WS_URL = "ws://localhost:4123/socket";
  const [channel, setChannel] = useState(null);
  const [messages, setMessages] = useState([]);

  useEffect(() => {
    let socket = new Socket(WS_URL, { params: { userToken: "TOKEN" } });
    socket.connect();

    const infoChannel = socket.channel("clients:info", {});
    infoChannel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp); })
      .receive("error", resp => { console.log("Unable to join", resp); });

    setChannel(infoChannel);

    infoChannel.on("clients", payload => {
      console.log("Received clients", payload);
      setMessages(messages => [...messages, payload.body]);
    });

    infoChannel.on("new_client", payload => {
      console.log("Received new client", payload);
      setMessages(messages => [...messages, payload.body]);
    });

    return () => {
      infoChannel.leave();
      socket.disconnect();
    };
  }, []);

  return (
    <>
      <div>
        {messages.map((msg, index) => (
          <p key={index}>{msg}</p>
        ))}
      </div>
    </>
  );
}

export default App;
