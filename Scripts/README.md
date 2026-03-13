# 汉化辅助脚本

**相关原模组路径（查 Def/结构时直接用，不必再问）：**
- **SpeakUp**：工坊 ID `2502518544`，1.6 版路径  
  `Steam\steamapps\workshop\content\294100\2502518544\1.6`

---

## fix-grammar-identifiers.ps1

**作用**：批量修正 DefInjected 里被误翻的「语法规则标识符」（如 `激情`→`passion`、`疼痛`→`Pain`），避免游戏报错 `Bad string pass when reading rule`、`Grammar unresolvable`。

**何时用**：
- 更新/合并汉化后跑一遍，防止规则名、条件变量被翻译
- 游戏中出现新的 “Bad string pass” 报错时，在脚本里加一条替换后再跑

**怎么跑**（PowerShell，模组根目录即 `DD-oher zh` 下执行）：

```powershell
.\Scripts\fix-grammar-identifiers.ps1
```

或指定根目录：

```powershell
.\Scripts\fix-grammar-identifiers.ps1 -Root "C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods\DD-oher zh"
```

**如何加新的替换**：  
编辑同目录下的 **`grammar-fix-pairs.csv`**，每行一条：`错误标识符,正确英文标识符`。例如新增一行：

```
INITIATOR_xxx_误翻,INITIATOR_xxx_correct
```

保存为 UTF-8 后重新运行脚本即可。只改「规则/条件」里的英文标识符，不要改显示用的中文句子。
