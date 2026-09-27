from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

required = {
    "main.lua",
    "social_hub.lua",
    "activities_zone.lua",
    "transport_system.lua",
    "customization_system.lua",
    "model.lua",
    "setup.lua",
}

missing = sorted(name for name in required if not (SRC / name).exists())
if missing:
    raise SystemExit(f"Missing required Roblox source modules: {missing}")

sources = "\n".join(
    path.read_text(encoding="utf-8")
    for path in sorted(SRC.glob("*.lua"))
)

blocked_patterns = {
    "absolute local filesystem path": r"(?:/Users/|/home/|[A-Za-z]:\\\\Users\\\\)",
    "email address": r"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b",
    "hard-coded credential label/value": r"(?i)(?:password|api[_-]?key|secret|token)\s*=\s*['\"][^'\"]+['\"]",
    "dynamic code execution": r"(?i)\bloadstring\s*\(",
    "arbitrary outbound HTTP": r"(?i)(?:HttpGet|RequestAsync|PostAsync|GetAsync)\s*\(",
}

violations = []
for label, pattern in blocked_patterns.items():
    if re.search(pattern, sources, flags=re.MULTILINE):
        violations.append(label)

if violations:
    raise SystemExit("Repository contract violations: " + ", ".join(violations))

# RemoteEvents are expected, but server-side handlers must remain visible in source
# rather than being dynamically loaded from external code.
remote_handlers = len(re.findall(r"\.OnServerEvent:Connect\s*\(", sources))
print(f"Roblox repository contract passed; server RemoteEvent handlers found: {remote_handlers}")
