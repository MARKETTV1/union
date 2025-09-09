
#!/bin/sh

# ألوان للoutput
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# متغيرات
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/MARKETTV1/Uni_Stalker/refs/heads/main/install.sh"
TEMP_DIR="/tmp"
TARGET_DIR="/usr/lib/enigma2/python/Plugins/Extensions"

# دالة للطباعة الملونة
print_status() {
    echo "${GREEN}✅ $1${NC}"
}

print_error() {
    echo "${RED}❌ $1${NC}"
}

print_warning() {
    echo "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo "${BLUE}ℹ️  $1${NC}"
}

# التحقق من صلاحية root
if [ $(id -u) -ne 0 ]; then
    print_error "يجب تشغيل السكريبت كـ root أو باستخدام sudo"
    exit 1
fi

print_info "بدء تثبيت Uni_Stalker..."

# الخطوة 1: التحقق من الأدوات المطلوبة
print_info "التحقق من الأدوات المطلوبة..."
if ! command -v wget >/dev/null 2>&1; then
    print_warning "wget غير مثبت. جاري التثبيت..."
    opkg update >/dev/null 2>&1 && opkg install wget >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        print_error "فشل في تثبيت wget"
        exit 1
    fi
fi

if ! command -v tar >/dev/null 2>&1; then
    print_error "tar غير مثبت"
    exit 1
fi

# الخطوة 2: تحميل سكريبت التثبيت
print_info "جاري تحميل سكريبت التثبيت..."
wget -q "$INSTALL_SCRIPT_URL" -O "$TEMP_DIR/install.sh"

if [ $? -ne 0 ]; then
    print_error "فشل في تحميل سكريبت التثبيت"
    exit 1
fi

print_status "تم تحميل سكريبت التثبيت بنجاح"

# الخطوة 3: جعل السكريبت قابلاً للتنفيذ
chmod +x "$TEMP_DIR/install.sh"

# الخطوة 4: تشغيل سكريبت التثبيت الأصلي
print_info "جاري تشغيل سكريبت التثبيت الأصلي..."
"$TEMP_DIR/install.sh"

if [ $? -ne 0 ]; then
    print_error "فشل سكريبت التثبيت الأصلي"
    exit 1
fi

# الخطوة 5: التحقق من التثبيت
print_info "جاري التحقق من التثبيت النهائي..."

if [ -d "$TARGET_DIR/Uni_Stalker" ]; then
    print_status "✅ تم التثبيت بنجاح!"
    echo ""
    print_info "المسار: $TARGET_DIR/Uni_Stalker"
    print_info "حجم المجلد: $(du -sh $TARGET_DIR/Uni_Stalker 2>/dev/null | cut -f1 || echo 'غير معروف')"
    
    # عرض محتويات المجلد
    echo ""
    print_info "محتويات المجلد المثبت:"
    ls -la "$TARGET_DIR/Uni_Stalker"
else
    print_warning "لم يتم العثور على المجلد في المسار المتوقع"
    print_info "جاري البحث في النظام..."
    
    # البحث عن الملفات المثبتة
    FIND_RESULT=$(find /usr -name "*Stalker*" -type d 2>/dev/null | head -1)
    if [ -n "$FIND_RESULT" ]; then
        print_status "تم العثور على البلوجين في: $FIND_RESULT"
    else
        print_error "لم يتم العثور على البلوجين في النظام"
    fi
fi

# الخطوة 6: التنظيف
print_info "جاري التنظيف..."
rm -f "$TEMP_DIR/install.sh"

echo ""
print_warning "يرجى إعادة تشغيل enigma2 لتطبيق التغييرات:"
echo "init 4 && sleep 2 && init 3"
echo "أو إعادة تشغيل الجهاز"

print_status "🎉 عملية التثبيت اكتملت!"
