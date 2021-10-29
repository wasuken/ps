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

