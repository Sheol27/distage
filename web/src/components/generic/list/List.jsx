import React from "react";
import ListItem from "./ListItem";

function List({ items, selectedItemId, onItemSelected }) {
  const getType = (status) => (status === "running" ? "success" : "error");

  return (
    <div>
      {items.map((x, i) => (
        <ListItem
          key={x.id}
          index={i}
          mainText={x.hostname}
          labelText={x.status}
          labelType={getType(x.status)}
          selected={i === selectedItemId}
          onItemSelected={onItemSelected}
        />
      ))}
    </div>
  );
}

export default List;
