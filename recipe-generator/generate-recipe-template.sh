#!/bin/bash
# Generate Recipe Template

DATE=$(date +%Y-%m-%d-%H:%M:%S)
GENERATED_RECIPE_TEMPLATE_NAME="recipe.sh"
GENERATED_RECIPE_TEMPLATE_FILE="../$GENERATED_RECIPE_TEMPLATE_NAME"
INGREDIENT_HEADER_REGEX="(?<=#\|).+"
HR="# --------------------------------------------------------------------------"

function main() {
    
    if [[ "$#" -eq 1 ]]; then
        GENERATED_RECIPE_TEMPLATE_FILE="$1"
        GENERATED_RECIPE_TEMPLATE_NAME=$(basename $1)
    fi

    generate-recipe
}

function generate-recipe() {

    echo "#!/bin/bash" > $GENERATED_RECIPE_TEMPLATE_FILE
    echo "# $GENERATED_RECIPE_TEMPLATE_NAME : $DATE" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "# NOTE: Please uncomment the ingredients you wish to install before running!" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo $HR >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "function main() {" >> $GENERATED_RECIPE_TEMPLATE_FILE

    generate-recipe-section "# 1. Core" "../ingredients/core"
    generate-recipe-section "# 2. Development" "../ingredients/dev"
    generate-recipe-section "# 3. Web" "../ingredients/web"
    generate-recipe-section "# 4. Productivity" "../ingredients/productivity"
    generate-recipe-section "# 5. Media" "../ingredients/media"
    generate-recipe-section "# 6. Gaming" "../ingredients/gaming"
    generate-recipe-section "# 7. Hardware Related" "../ingredients/hardware"
    generate-recipe-section "# 8. System Monitoring" "../ingredients/system-monitor"
    generate-recipe-section "# 9. VM" "../ingredients/vm"
    generate-recipe-section "# 10. Icons" "../ingredients/icons"
    generate-recipe-section "# 11. Fonts" "../ingredients/fonts"
    generate-recipe-section "# 12. Themes" "../ingredients/themes"

    echo "" >> $GENERATED_RECIPE_TEMPLATE_FILE
    
    echo "# 14. Additional Packages" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo $HR >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "# paru -S --noconfirm --needed {package1} {package2} ..." >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "" >> $GENERATED_RECIPE_TEMPLATE_FILE

    echo "}" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo "" >> $GENERATED_RECIPE_TEMPLATE_FILE

    echo 'main "$@"' >> $GENERATED_RECIPE_TEMPLATE_FILE

    chmod +x $GENERATED_RECIPE_TEMPLATE_FILE
}

function generate-recipe-section() {

    SECTION_LABEL=$1
    INGREDIENT_DIR=$2

    echo "" >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo $SECTION_LABEL >> $GENERATED_RECIPE_TEMPLATE_FILE
    echo $HR >> $GENERATED_RECIPE_TEMPLATE_FILE

    for i in ${INGREDIENT_DIR}/*.sh; do
        cat $i | grep -P -o $INGREDIENT_HEADER_REGEX >> $GENERATED_RECIPE_TEMPLATE_FILE
    done
}

main "$@"