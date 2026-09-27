# Validation boundary

This repository contains Roblox/Luau source intended to be assembled and tested in Roblox Studio.

GitHub CI deliberately does **not** claim to validate Roblox runtime behavior or full Luau semantics. The repository contract only checks source structure and public-repository safety properties such as:

- required source modules are present;
- no local absolute filesystem paths;
- no obvious hard-coded credentials;
- no dynamic `loadstring` execution;
- no arbitrary outbound HTTP calls in the checked-in game scripts.

Gameplay, RemoteEvent behavior, permissions and Roblox API compatibility still require Roblox Studio/runtime testing.
