import React, { useEffect, useMemo, useState } from "react";
import "./ListItem.css";
import Badge from "../badge/Badge";

const ListItem = ({
  index,
  mainText,
  labelText,
  labelType,
  selected,
  onItemSelected,
}) => {
  const renderSelection = () => (selected ? "list-item-selected" : "");

  return (
    <div
      className={`list-item-container ${renderSelection()}`}
      onClick={() => onItemSelected(index)}
    >
      <div className="list-item-text">{mainText}</div>
      <div className="list-item-label">
        <Badge text={labelText} type={labelType}></Badge>
      </div>
    </div>
  );
};

export default ListItem;
