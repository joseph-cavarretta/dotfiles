from collections.abc import Callable, Sequence
from contextlib import AbstractContextManager
from stat import S_IMODE as S_IMODE
from types import TracebackType
from typing import IO, Literal
from typing_extensions import Self, TypeAlias

import paramiko
from paramiko import AuthenticationException as AuthenticationException
from pysftp.exceptions import (
    ConnectionException as ConnectionException,
    CredentialException as CredentialException,
    HostKeysException as HostKeysException,
)
from pysftp.helpers import (
    WTCallbacks as WTCallbacks,
    _PathCallback,
    cd as cd,
    known_hosts as known_hosts,
    path_advance as path_advance,
    path_retreat as path_retreat,
    reparent as reparent,
    st_mode_to_int as st_mode_to_int,
    walktree as walktree,
)

class CnOpts:
    log: bool
    compression: bool
    ciphers: Sequence[str] | None
    hostkeys: paramiko.HostKeys | None
    def __init__(self, knownhosts: str | None = None) -> None: ...
    def get_hostkey(self, host: str) -> paramiko.PKey: ...

_Callback: TypeAlias = Callable[[int, int], object]
_Path: TypeAlias = str | bytes

class Connection:
    def __init__(
        self,
        host: str,
        username: str | None = None,
        private_key: str | paramiko.RSAKey | paramiko.AgentKey | None = None,
        password: str | None = None,
        port: int = 22,
        private_key_pass: str | None = None,
        ciphers: Sequence[str] | None = None,
        log: bool = False,
        cnopts: CnOpts | None = None,
        default_path: _Path | None = None,
    ) -> None: ...
    @property
    def pwd(self) -> str: ...
    def get(
        self, remotepath: _Path, localpath: _Path | None = None, callback: _Callback | None = None, preserve_mtime: bool = False
    ) -> None: ...
    def get_d(self, remotedir: _Path, localdir: _Path, preserve_mtime: bool = False) -> None: ...
    def get_r(self, remotedir: _Path, localdir: _Path, preserve_mtime: bool = False) -> None: ...
    def getfo(self, remotepath: _Path, flo: IO[bytes], callback: _Callback | None = None) -> int: ...
    def put(
        self,
        localpath: _Path,
        remotepath: _Path | None = None,
        callback: _Callback | None = None,
        confirm: bool = True,
        preserve_mtime: bool = False,
    ) -> paramiko.SFTPAttributes: ...
    def put_d(self, localpath: _Path, remotepath: _Path, confirm: bool = True, preserve_mtime: bool = False) -> None: ...
    def put_r(self, localpath: _Path, remotepath: _Path, confirm: bool = True, preserve_mtime: bool = False) -> None: ...
    def putfo(
        self,
        flo: IO[bytes],
        remotepath: _Path | None = None,
        file_size: int = 0,
        callback: _Callback | None = None,
        confirm: bool = True,
    ) -> paramiko.SFTPAttributes: ...
    def execute(self, command: str) -> list[str]: ...
    def cd(self, remotepath: _Path | None = None) -> AbstractContextManager[None]: ...  # noqa: F811
    def chdir(self, remotepath: _Path) -> None: ...
    def cwd(self, remotepath: _Path) -> None: ...
    def chmod(self, remotepath: _Path, mode: int = 777) -> None: ...
    def chown(self, remotepath: _Path, uid: int | None = None, gid: int | None = None) -> None: ...
    def getcwd(self) -> str: ...
    def listdir(self, remotepath: _Path = ".") -> list[str]: ...
    def listdir_attr(self, remotepath: _Path = ".") -> list[paramiko.SFTPAttributes]: ...
    def mkdir(self, remotepath: _Path, mode: int = 777) -> None: ...
    def normalize(self, remotepath: _Path) -> str: ...
    def isdir(self, remotepath: _Path) -> bool: ...
    def isfile(self, remotepath: _Path) -> bool: ...
    def makedirs(self, remotedir: _Path, mode: int = 777) -> None: ...
    def readlink(self, remotelink: _Path) -> str: ...
    def remove(self, remotefile: _Path) -> None: ...
    def unlink(self, remotefile: _Path) -> None: ...
    def rmdir(self, remotepath: _Path) -> None: ...
    def rename(self, remote_src: _Path, remote_dest: _Path) -> None: ...
    def stat(self, remotepath: _Path) -> paramiko.SFTPAttributes: ...
    def lstat(self, remotepath: _Path) -> paramiko.SFTPAttributes: ...
    def close(self) -> None: ...
    def open(self, remote_file: _Path, mode: str = "r", bufsize: int = -1) -> paramiko.SFTPFile: ...
    def exists(self, remotepath: _Path) -> bool: ...
    def lexists(self, remotepath: _Path) -> bool: ...
    def symlink(self, remote_src: _Path, remote_dest: _Path) -> None: ...
    def truncate(self, remotepath: _Path, size: int) -> int: ...
    def walktree(  # noqa: F811
        self,
        remotepath: _Path,
        fcallback: _PathCallback,
        dcallback: _PathCallback,
        ucallback: _PathCallback,
        recurse: bool = True,
    ) -> None: ...
    @property
    def sftp_client(self) -> paramiko.SFTPClient: ...
    @property
    def active_ciphers(self) -> tuple[str, str]: ...
    @property
    def active_compression(self) -> tuple[str, str]: ...
    @property
    def security_options(self) -> paramiko.SecurityOptions: ...
    @property
    def logfile(self) -> str | Literal[False]: ...
    @property
    def timeout(self) -> float | None: ...
    @timeout.setter
    def timeout(self, val: float | None) -> None: ...
    @property
    def remote_server_key(self) -> paramiko.PKey: ...
    def __del__(self) -> None: ...
    def __enter__(self) -> Self: ...
    def __exit__(
        self, etype: type[BaseException] | None, value: BaseException | None, traceback: TracebackType | None
    ) -> None: ...
