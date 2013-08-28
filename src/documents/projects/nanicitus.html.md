---
title: 'nAnicitus'
description: "nAnicitus is a windows service that acts as a gatekeeper for the SymStore application."
---

[nAnicitus](https://github.com/pvandervelde/nAnicitus) is a windows service that acts as a gatekeeper for the [SymStore][symstore_msdn] application. SymStore provides a relatively simple way to create 
a local / private symbol server with the disadvantage that it should really only be called by one user at the time because it doesn't support [multiple transactions at the same time][symstore_msdn_singletransaction]. 
The nAnicitus windows service 'serializes' access to SymStore to allow multiple users to add symbols to the symbol server.

Besides handling the the access to the symbol server nAnicitus also copies the sources into a UNC source location for access by a source server and performs [source indexing][sourceindexing_msdn] on the PDB files 
before they are stored in the symbol UNC path.

[symstore_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558848(v=vs.85).aspx
[symstore_msdn_singletransaction]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff558851(v=vs.85).aspx
[sourceindexing_msdn]: http://msdn.microsoft.com/en-us/library/windows/hardware/ff556898(v=vs.85).aspx
