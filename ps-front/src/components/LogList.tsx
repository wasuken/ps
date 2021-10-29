import { useState } from "react";
import { useRecoilValue, useRecoilState } from "recoil";
import { Ping, nodeListState, pingListState } from "../atoms/api";
import { fetchNodeListState } from "../selectors/api";

import Button from "@mui/material/Button";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";
import { LineChart, Line, CartesianGrid, XAxis, YAxis } from "recharts";

interface IPingResponseData {
  node_name: string;
  result: boolean;
  duration: number;
  created_at: string;
}

function LogList() {
  const nodeList = useRecoilValue(fetchNodeListState);
  const [pingList, setPingList] = useRecoilState(pingListState);
  const updatePingList = function (node: string) {
    fetch(`/api/v1/node/pings?node=${node}`)
      .then((res) => res.json())
      .then((json) => {
        const data: IPingResponseData[] = json.data;
        const header: string[] = json.header;

        let conv_map: { [key: string]: number } = {};
        header.map((h: string, i: number) => {
          conv_map[h] = i;
        });
        const fmt_data = data.map((r) => {
          const dt = new Date(Date.parse(r.created_at));
          const dtf =
            ("0" + (dt.getMonth() + 1)).slice(-2) +
            "/" +
            ("0" + (dt.getDate())).slice(-2);
          const tf =
            ("0" + dt.getHours()).slice(-2) +
            ":" +
            ("0" + dt.getMinutes()).slice(-2) +
            ":" +
            ("0" + dt.getSeconds()).slice(-2);

          const rst: Ping = {
            node_name: r.node_name,
            result: r.result,
            duration: r.duration,
            created_at: r.created_at,
            date: dtf,
            time: tf,
          };
          return rst;
        });
        setPingList(fmt_data);
      });
  };
  return (
    <div>
      <List>
        {nodeList.map((node) => (
          <ListItem>
            <ListItemButton onClick={() => updatePingList(node)}>
              <ListItemText>{node}</ListItemText>
            </ListItemButton>
          </ListItem>
        ))}
      </List>
      <hr />
      {pingList.length > 0 ? (
        <div>
          <h2>{pingList[0].date}</h2>
          <LineChart width={800} height={400} data={pingList}>
            <Line type="monotone" dataKey="duration" stroke="#8884d8" />
            <CartesianGrid stroke="#ccc" />
            <XAxis dataKey="time" />
            <YAxis />
          </LineChart>
        </div>
      ) : (
        <div></div>
      )}
    </div>
  );
}

export default LogList;
