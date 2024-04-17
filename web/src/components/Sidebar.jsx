import React, { useEffect } from "react";
import List from "./generic/list/List";

function Sidebar({ clients, selectedItemId, onItemSelected }) {
  return (
    <div className="sidebar">
      <List
        items={clients}
        selectedItemId={selectedItemId}
        onItemSelected={onItemSelected}
      ></List>
    </div>
  );
}

export default Sidebar;
