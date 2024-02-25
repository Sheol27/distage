import React from "react";

function Panel({ headerText, logs }) {
  const formatDate = (timestamp) => {
    const date = new Date(timestamp * 1000);
    const day = date.getDate().toString().padStart(2, "0");
    const month = (date.getMonth() + 1).toString().padStart(2, "0");
    const year = date.getFullYear();
    const hours = date.getHours().toString().padStart(2, "0");
    const minutes = date.getMinutes().toString().padStart(2, "0");
    const seconds = date.getSeconds().toString().padStart(2, "0");
    return `${day}/${month}/${year} - ${hours}:${minutes}:${seconds}`;
  };
  return (
    <>
      <div className="panel">
        <div className="panel-header">{headerText}</div>
        <div className="panel-content">
          {logs.map((x) => (
            <p>
              <b>{formatDate(x.timestamp)}: </b>
              {x.message}
            </p>
          ))}
        </div>
      </div>
    </>
  );
}

export default Panel;
