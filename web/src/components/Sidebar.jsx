import React, { useEffect } from "react";
import List from "./generic/list/List";

function Sidebar({ clients, selectedItemId, onItemSelected }) {
  return (
    <div className="sidebar">
      <div className="sidebar-header">
        <span>DISTAGE</span>
      </div>
      <div className="sidebar-content">
        <List
          items={clients}
          selectedItemId={selectedItemId}
          onItemSelected={onItemSelected}
        ></List>
      </div>
    </div>
  );
}

export default Sidebar;
