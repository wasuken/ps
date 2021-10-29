import { selector } from "recoil";
import { inputNodeState } from "../atoms/api";

export const fetchNodeListState = selector<string[]>({
  key: "selector/fetchNodeList",
  get: async ({ get }) => {
    const res = await fetch("/api/v1/nodes");
    const json = await res.json();

    return json.data;
  },
});

export const fetchNodePingListState = selector({
  key: "selector/fetchNodePongList",
  get: async ({ get }) => {
    const node_name = get(inputNodeState);
    if (!node_name || node_name.length <= 0) {
      return [];
    }
    const res = await fetch("/api/v1/node/ping");
    const json = await res.json();
    const data = json.data;
    const header = json.header;

    let conv_map = {};
    header.map((h, i) => {
      conv_map[h] = i;
    });
    return data.map((r) => {
      return {
        node_name: r[conv_map[header.find((h) => h === "node_name")]],
        result: r[conv_map[header.find((h) => h === "result")]],
        duration: r[conv_map[header.find((h) => h === "duration")]],
        created_at: r[conv_map[header.find((h) => h === "created_at")]],
      };
    });
  },
});
