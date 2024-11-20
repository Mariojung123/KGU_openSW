import React, { useState } from 'react';
import "../styles/components/Sidebar.css";

const Sidebar = ({ isOpen, toggleSidebar }) => {

return (
    <div>
        <button className="sidebar-toggle" onClick={toggleSidebar}>
            ☰
        </button>
        <div className={`sidebar ${isOpen ? "open" : ""}`}>
            <h2>My Sidebar</h2>
            <div id="side-items">
                <a href="/">Home</a>
                <a href="/about">About</a>
                <a href="/services">Services</a>
                <a href="/contact">Contact</a>
                <button className="auth-button">Login</button>
            </div>
        </div>
    </div>
);
};

export default Sidebar;
