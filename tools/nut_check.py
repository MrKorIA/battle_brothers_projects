import sys

def check(path):
    s = open(path, encoding='utf-8').read()
    stack = []
    line = 1
    i = 0
    instr = None
    esc = False
    pairs = {')': '(', ']': '[', '}': '{'}
    while i < len(s):
        c = s[i]
        if c == '\n':
            line += 1
        if instr is not None:
            if esc:
                esc = False
            elif c == chr(92):
                esc = True
            elif c == instr:
                instr = None
        else:
            if c == '"' or c == chr(39):
                instr = c
            elif c == '/' and i + 1 < len(s) and s[i + 1] == '/':
                while i < len(s) and s[i] != '\n':
                    i += 1
                continue
            elif c == '/' and i + 1 < len(s) and s[i + 1] == '*':
                i += 2
                while i + 1 < len(s) and not (s[i] == '*' and s[i + 1] == '/'):
                    if s[i] == '\n':
                        line += 1
                    i += 1
                i += 1
            elif c in '([{':
                stack.append((c, line))
            elif c in ')]}':
                if not stack or stack[-1][0] != pairs[c]:
                    print(path + ": MISMATCH " + c + " at line " + str(line))
                    return False
                stack.pop()
        i += 1
    if stack:
        print(path + ": UNCLOSED " + str(stack[-1]))
        return False
    print(path + ": OK")
    return True

ok = check(r"bb_vanilla_plus/scripts/items/armor/vp_vestal_armor.nut")
ok = check(r"bb_vanilla_plus/mod_vanilla_plus/hooks/items/item_container.nut") and ok
sys.exit(0 if ok else 1)
