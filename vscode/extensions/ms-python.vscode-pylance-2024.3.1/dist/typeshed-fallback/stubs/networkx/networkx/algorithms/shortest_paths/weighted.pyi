from _typeshed import Incomplete
from collections.abc import Generator

from networkx.utils.backends import _dispatch

@_dispatch
def dijkstra_path(G, source, target, weight: str = "weight"): ...
@_dispatch
def dijkstra_path_length(G, source, target, weight: str = "weight"): ...
@_dispatch
def single_source_dijkstra_path(G, source, cutoff: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def single_source_dijkstra_path_length(G, source, cutoff: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def single_source_dijkstra(
    G, source, target: Incomplete | None = None, cutoff: Incomplete | None = None, weight: str = "weight"
): ...
@_dispatch
def multi_source_dijkstra_path(G, sources, cutoff: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def multi_source_dijkstra_path_length(G, sources, cutoff: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def multi_source_dijkstra(
    G, sources, target: Incomplete | None = None, cutoff: Incomplete | None = None, weight: str = "weight"
): ...
@_dispatch
def dijkstra_predecessor_and_distance(G, source, cutoff: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def all_pairs_dijkstra(G, cutoff: Incomplete | None = None, weight: str = "weight") -> Generator[Incomplete, None, None]: ...
@_dispatch
def all_pairs_dijkstra_path_length(
    G, cutoff: Incomplete | None = None, weight: str = "weight"
) -> Generator[Incomplete, None, None]: ...
@_dispatch
def all_pairs_dijkstra_path(G, cutoff: Incomplete | None = None, weight: str = "weight") -> Generator[Incomplete, None, None]: ...
@_dispatch
def bellman_ford_predecessor_and_distance(
    G, source, target: Incomplete | None = None, weight: str = "weight", heuristic: bool = False
): ...
@_dispatch
def bellman_ford_path(G, source, target, weight: str = "weight"): ...
@_dispatch
def bellman_ford_path_length(G, source, target, weight: str = "weight"): ...
@_dispatch
def single_source_bellman_ford_path(G, source, weight: str = "weight"): ...
@_dispatch
def single_source_bellman_ford_path_length(G, source, weight: str = "weight"): ...
@_dispatch
def single_source_bellman_ford(G, source, target: Incomplete | None = None, weight: str = "weight"): ...
@_dispatch
def all_pairs_bellman_ford_path_length(G, weight: str = "weight") -> Generator[Incomplete, None, None]: ...
@_dispatch
def all_pairs_bellman_ford_path(G, weight: str = "weight") -> Generator[Incomplete, None, None]: ...
@_dispatch
def goldberg_radzik(G, source, weight: str = "weight"): ...
@_dispatch
def negative_edge_cycle(G, weight: str = "weight", heuristic: bool = True): ...
@_dispatch
def find_negative_cycle(G, source, weight: str = "weight"): ...
@_dispatch
def bidirectional_dijkstra(G, source, target, weight: str = "weight"): ...
@_dispatch
def johnson(G, weight: str = "weight"): ...
