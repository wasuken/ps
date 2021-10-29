import { useState, Suspense } from "react";
import { RecoilRoot, useRecoilState } from "recoil";
import logo from "./logo.svg";
import "./App.css";

import Header from "./components/Header";
import LogList from "./components/LogList";

function App() {
  return (
    <RecoilRoot>
      <Header />
      <Suspense fallback={<div>Loading... </div>}>
        <LogList />
      </Suspense>
    </RecoilRoot>
  );
}

export default App;
