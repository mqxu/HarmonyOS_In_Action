#!/bin/bash

##############################################################################
# 链接验证脚本
# 功能：扫描所有 Markdown 文件中的 HTTP(S) 链接并验证有效性
# 使用：./scripts/verify_links.sh
##############################################################################

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 统计变量
TOTAL_LINKS=0
VALID_LINKS=0
INVALID_LINKS=0
WARNING_LINKS=0

# 报告文件
REPORT_FILE="docs/link_verification_report.md"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   链接验证工具${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 初始化报告文件
cat > "$REPORT_FILE" << 'EOF'
# 链接验证报告

**生成时间**: $(date '+%Y-%m-%d %H:%M:%S')

## 验证结果统计

| 状态 | 数量 |
|------|------|
| ✅ 有效 | VALID_COUNT |
| ❌ 失效 | INVALID_COUNT |
| ⚠️ 警告 | WARNING_COUNT |
| **总计** | **TOTAL_COUNT** |

---

## 详细结果

EOF

# 临时文件存储所有链接
TEMP_LINKS=$(mktemp)

# 扫描所有 .md 文件，提取链接
echo -e "${YELLOW}正在扫描 Markdown 文件...${NC}"
find . -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*" | while read -r file; do
  # 提取 HTTP(S) 链接（排除 shields.io 等徽章链接）
  grep -oE 'https?://[^\)\"<> ]+' "$file" | grep -v "shields.io" | grep -v "badge" >> "$TEMP_LINKS" || true
done

# 去重并排序
sort -u "$TEMP_LINKS" > "${TEMP_LINKS}.sorted"
mv "${TEMP_LINKS}.sorted" "$TEMP_LINKS"

# 读取链接总数
TOTAL_LINKS=$(wc -l < "$TEMP_LINKS" | tr -d ' ')
echo -e "${BLUE}找到 $TOTAL_LINKS 个唯一链接${NC}"
echo ""

# 验证每个链接
echo -e "${YELLOW}开始验证链接...${NC}"
echo ""

while IFS= read -r url; do
  # 跳过空行
  [ -z "$url" ] && continue

  # 跳过本地链接和示例链接
  if [[ "$url" == *"example.com"* ]] || [[ "$url" == *"localhost"* ]] || [[ "$url" == *"127.0.0.1"* ]]; then
    echo -e "⏭️  跳过示例链接: $url"
    echo "| ⏭️ 跳过 | $url | 示例链接 |" >> "$REPORT_FILE"
    continue
  fi

  # 使用 curl 验证链接（超时 10 秒）
  HTTP_CODE=$(curl -o /dev/null -s -w "%{http_code}" -L --max-time 10 "$url" 2>/dev/null || echo "000")

  if [ "$HTTP_CODE" = "200" ]; then
    echo -e "${GREEN}✅ $url${NC}"
    echo "| ✅ 有效 | $url | HTTP 200 |" >> "$REPORT_FILE"
    ((VALID_LINKS++))
  elif [ "$HTTP_CODE" = "404" ]; then
    echo -e "${RED}❌ $url (404 Not Found)${NC}"
    echo "| ❌ 失效 | $url | HTTP 404 - 页面不存在 |" >> "$REPORT_FILE"
    ((INVALID_LINKS++))
  elif [ "$HTTP_CODE" = "403" ]; then
    echo -e "${YELLOW}⚠️  $url (403 Forbidden - 可能需要登录或被防火墙拦截)${NC}"
    echo "| ⚠️ 警告 | $url | HTTP 403 - 禁止访问 |" >> "$REPORT_FILE"
    ((WARNING_LINKS++))
  elif [ "$HTTP_CODE" = "000" ]; then
    echo -e "${RED}❌ $url (连接超时或无法访问)${NC}"
    echo "| ❌ 失效 | $url | 连接超时或网络错误 |" >> "$REPORT_FILE"
    ((INVALID_LINKS++))
  else
    echo -e "${YELLOW}⚠️  $url (HTTP $HTTP_CODE)${NC}"
    echo "| ⚠️ 警告 | $url | HTTP $HTTP_CODE |" >> "$REPORT_FILE"
    ((WARNING_LINKS++))
  fi

done < "$TEMP_LINKS"

# 更新报告文件中的统计数据
sed -i.bak "s/VALID_COUNT/$VALID_LINKS/g" "$REPORT_FILE"
sed -i.bak "s/INVALID_COUNT/$INVALID_LINKS/g" "$REPORT_FILE"
sed -i.bak "s/WARNING_COUNT/$WARNING_LINKS/g" "$REPORT_FILE"
sed -i.bak "s/TOTAL_COUNT/$TOTAL_LINKS/g" "$REPORT_FILE"
rm "${REPORT_FILE}.bak"

# 添加建议部分
cat >> "$REPORT_FILE" << 'EOF'

---

## 修复建议

### ❌ 失效链接处理方案

1. **404 错误**：链接已失效，需要删除或更换
2. **连接超时**：可能是网络问题或域名失效

### ⚠️ 警告链接处理方案

1. **403 错误**：页面可能需要登录，或被防火墙拦截
   - 验证是否需要华为开发者账号登录
   - 考虑更换为公开访问链接
2. **其他状态码**：检查链接是否重定向或临时不可用

### ✅ 最佳实践

1. **优先使用官方一级域名链接**
   - ✅ `https://developer.huawei.com/consumer/cn/`
   - ❌ `https://developer.huawei.com/consumer/cn/doc/some-deep-path-that-might-change`

2. **对于具体文档页面**
   - 先在官网搜索确认页面存在
   - 复制浏览器地址栏的实际 URL
   - 添加注释标注验证日期

3. **内部链接使用相对路径**
   - ✅ `[文档](docs/guide.md)`
   - ❌ `[文档](https://github.com/xxx/project/docs/guide.md)`

4. **不确定的链接标注占位符**
   - ✅ `文档待补充`
   - ❌ `[文档](https://fake-url.com)`

---

**下次验证**: 建议每月运行一次此脚本

EOF

# 清理临时文件
rm -f "$TEMP_LINKS"

# 输出总结
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   验证完成${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "总链接数: $TOTAL_LINKS"
echo -e "${GREEN}✅ 有效: $VALID_LINKS${NC}"
echo -e "${RED}❌ 失效: $INVALID_LINKS${NC}"
echo -e "${YELLOW}⚠️  警告: $WARNING_LINKS${NC}"
echo ""
echo -e "详细报告已生成: ${BLUE}$REPORT_FILE${NC}"
echo ""

# 如果有失效链接，返回错误码
if [ "$INVALID_LINKS" -gt 0 ]; then
  echo -e "${RED}⚠️  发现 $INVALID_LINKS 个失效链接，请查看报告并修复！${NC}"
  exit 1
else
  echo -e "${GREEN}✅ 所有链接验证通过！${NC}"
  exit 0
fi
