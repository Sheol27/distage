import React from "react";
import './Badge.css'

function Badge({ text, type }) {

  return <div className={`badge ${type}`}>{text}</div>
}

export default Badge
