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

    generate-recipe-section "# Shell" "../ingredients/shell"
    generate-recipe-section "# Filesystem" "../ingredients/fs"
    generate-recipe-section "# System" "../ingredients/system"
    generate-recipe-section "# Editors" "../ingredients/editor"
    generate-recipe-section "# Development" "../ingredients/dev"
    generate-recipe-section "# Web" "../ingredients/web"
    generate-recipe-section "# Productivity" "../ingredients/productivity"
    generate-recipe-section "# Media" "../ingredients/media"
    generate-recipe-section "# Gaming" "../ingredients/gaming"
    generate-recipe-section "# VM" "../ingredients/vm"
    generate-recipe-section "# Icons" "../ingredients/icons"
    generate-recipe-section "# Fonts" "../ingredients/fonts"
    generate-recipe-section "# Hardware" "../ingredients/hardware"

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