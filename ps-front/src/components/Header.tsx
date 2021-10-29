import { useState } from "react";
import logo from "./logo.svg";
import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import IconButton from "@mui/material/IconButton";
import MenuIcon from "@mui/icons-material/Menu";

function Header() {
  return (
    <Box sx={{ flexGrow: 1 }}>
      <AppBar position="static">
        <Toolbar>
          <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="menu"
            sx={{ mr: 2 }}
          >
            <MenuIcon />
          </IconButton>
          <Box sx={{ paddingRight: "20px" }}>
            <Typography variant="h5" component="div">
              Ping Server
            </Typography>
          </Box>
          <Box>Top</Box>
        </Toolbar>
      </AppBar>
    </Box>
  );
}

export default Header;
