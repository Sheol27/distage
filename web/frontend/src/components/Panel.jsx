import React from "react";

function Panel({ headerText }) {
  return (
    <>
      <div className="panel">
        <div className="panel-content">{headerText}</div>
      </div>
    </>
  );
}

export default Panel;
