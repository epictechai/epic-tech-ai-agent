Epic Tech AI — Windows (fully local)
====================================

Your folder:
  C:\Users\epict\EpicTechAI

OPTION A — Easiest (empty folder)  *** USE THIS ***
----------------------------------------------------
1. Open this link, Save As into C:\Users\epict\EpicTechAI\
   https://raw.githubusercontent.com/epictechai/epic-tech-ai-agent/main/SETUP_AND_LAUNCH.bat

   (Right-click link → Save link as… → name must end with .bat)

2. Double-click:
   C:\Users\epict\EpicTechAI\SETUP_AND_LAUNCH.bat

   It clones the full repo and starts the local agent.

3. Next times, double-click:
   C:\Users\epict\EpicTechAI\epic-tech-ai-agent\LAUNCH.bat

OPTION B — Full ZIP
-------------------
1. Download:
   https://github.com/epictechai/epic-tech-ai-agent/archive/refs/heads/main.zip
2. Extract into C:\Users\epict\EpicTechAI\
3. Open the extracted folder
4. Double-click LAUNCH.bat   (or START_EPIC.bat)

OPTION C — Git
--------------
  cd C:\Users\epict\EpicTechAI
  git clone https://github.com/epictechai/epic-tech-ai-agent.git
  cd epic-tech-ai-agent
  LAUNCH.bat

Files you should see after install
----------------------------------
  LAUNCH.bat              <- double-click to run agent
  SETUP_AND_LAUNCH.bat    <- first-time setup
  START_EPIC.bat          <- same as LAUNCH.bat
  LAUNCH.ps1
  .kortix\                <- agent brain (required)

Prerequisite (once)
-------------------
  OpenCode CLI: https://opencode.ai/docs
  Then configure a model:  opencode providers

Site
----
  https://epictechai.github.io/epic-tech-ai-agent/
