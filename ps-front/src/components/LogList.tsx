import { useState } from "react";
import { useRecoilValue, useRecoilState } from "recoil";
import { nodeListState, pingListState } from "../atoms/api";
import { fetchNodePingListState, fetchNodeListState } from "../selectors/api";

import Button from "@mui/material/Button";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemButton from "@mui/material/ListItemButton";
import ListItemIcon from "@mui/material/ListItemIcon";
import ListItemText from "@mui/material/ListItemText";

function LogList() {
  const nodeList = useRecoilValue(fetchNodeListState);
  const [pingList, setPingList] = useRecoilState(pingListState);
  const updatePingList = function (node) {
    fetch(`/api/v1/node/pings?node=${node}`)
      .then((res) => res.json())
      .then((json) => {
        const data = json.data;
        const header = json.header;

        let conv_map = {};
        header.map((h, i) => {
          conv_map[h] = i;
        });
        const fmt_data = data.map((r) => {
          return {
            node_name: r[conv_map[header.find((h) => h === "node_name")]],
            result: r[conv_map[header.find((h) => h === "result")]],
            duration: r[conv_map[header.find((h) => h === "duration")]],
            created_at: r[conv_map[header.find((h) => h === "created_at")]],
          };
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
      <List>
        {pingList.map((p) => {
          const sub_label = `応答時間: ${p.duration}, 実行時間: ${p.created_at}`;
          return (
            <ListItem>
              <ListItemButton>
                <ListItemText
                  primary={p.result ? "成功" : "失敗"}
                  secondary={sub_label}
                />
              </ListItemButton>
            </ListItem>
          );
        })}
      </List>
    </div>
  );
}

export default LogList;
