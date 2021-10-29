import { atom, selector } from "recoil";

export type Ping = {
  node_name: string;
  result: boolean;
  duration: number;
  created_at: string;
  date: string;
  time: string;
}

export const nodeListState = atom({
  key: "atom/nodes",
  default: [] as string[],
});

export const pingListState = atom({
  key: "atom/pings",
  default: [] as Ping[],
});

export const inputNodeState = atom({
  key: "atom/inputNode",
  default: "",
});
