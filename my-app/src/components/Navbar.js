import React, { useState } from "react";
import "../styles/components/Navbar.css"; // 스타일을 위한 CSS 파일 (선택)
import Sidebar from "./Sidebar";

const Navbar = () => {
const [isSidebarOpen, setIsSidebarOpen] = useState(false);


const toggleSidebar = () => {
    setIsSidebarOpen(!isSidebarOpen);
};

return (
    <nav className="navbar">
    <div className="navbar-brand">
    </div>
    <button className="menu-toggle" onClick={toggleSidebar}>
        ☰
    </button>
    <ul className={`nav-links ${isSidebarOpen ? "open" : ""}`}>
        <li><a href="/">Home</a></li>
        <li><a href="/about">About</a></li>
        <li><a href="/services">Services</a></li>
        <li><a href="/contact">Contact</a></li>
    </ul>
    <Sidebar isOpen={isSidebarOpen} toggleSidebar={toggleSidebar} />
    </nav>
);
};

export default Navbar;
