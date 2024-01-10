# ==============================================================================
# DATOS DEL PROYECTO
# ==============================================================================
PROJECT = build_app
DESCRIPTION = "Contruye el proyecto con librerias empaquetadas"

# ==============================================================================
# CONFIGURACIONES ESTATICAS
# ==============================================================================
RUNTIME_VERSION = 3.8
VIRTUAL_ENV = .venv_temp
REQUIREMENTS = requirements.txt
LAMBDA_BUILD_DIR = ./package/tmp
FUNCTION_NAME = $(PROJECT)
PATH_FILE_HANDLER = main.py

# ==============================================================================
# CONFIGURACIONES DE COLORES
# ==============================================================================
HEADER = '\033[96m'
OKBLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
END = '\033[0m'
BOLD = '\033[1m'
UNDERLINE = '\033[4m'

# ==============================================================================
# DEFAULT COMMANDS
# ==============================================================================
build: virtual install_requirements clean_package build_package_tmp copy_python remove_unused zip
run: run_package

run_package:
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(HEADER)"Ejecutando funcion"$(END)
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@python$(RUNTIME_VERSION) ${LAMBDA_BUILD_DIR}/$(PATH_FILE_HANDLER)
	@+echo $(OKGREEN)"[OK] Funcion ejecutada"$(END)

virtual:
	@+echo "---------------------------------------------"$(END)
	@+echo  $(HEADER)"Instalando y activando entorno virtual"
	@+echo "---------------------------------------------"$(END)
	@+echo $(WARNING)""
	@if test ! -d "$(VIRTUAL_ENV)"; then \
		python$(RUNTIME_VERSION) -m venv $(VIRTUAL_ENV); \
	fi
	@+echo ""$(END)

install_requirements:
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(HEADER)"Instalando paquetes requeridos por el entorno"$(END)
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(WARNING)""
	@ $(VIRTUAL_ENV)/bin/pip --no-cache-dir install \
											--platform manylinux2014_x86_64 \
											--target=env_build \
											--python $(RUNTIME_VERSION) \
											--only-binary=:all: \
											-Ur $(REQUIREMENTS)
	@ touch $(VIRTUAL_ENV)/bin/activate
	@+echo $(OKGREEN)"[OK] Paquetes instalados"$(END)
	@+echo ""


clean_package:
	@rm -rf ./package/*

build_package_tmp:
	@+echo $(HEADER)"============================================="$(END)
	@+echo $(HEADER)"CONSTRUYENDO PACKAGE '"$(FUNCTION_NAME)"'" $(END)
	@+echo $(HEADER)"============================================="$(END)
	@mkdir -p ${LAMBDA_BUILD_DIR}/lib
	@cp -a ./src/. ${LAMBDA_BUILD_DIR}

copy_python:
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(HEADER)"Cargando librerias"$(END)
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@if test -d env_build; then \
		cp -a env_build/. ${LAMBDA_BUILD_DIR}; \
	fi
	@+echo $(OKGREEN)"[OK] Librerias cargadas"$(END)
	@+echo ""

remove_unused:
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(HEADER)"Eliminando archivos sin uso"$(END)
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@rm -rf ${LAMBDA_BUILD_DIR}/wheel*
	@rm -rf ${LAMBDA_BUILD_DIR}/easy-install*
	@rm -rf ${LAMBDA_BUILD_DIR}/easy_install*
	@rm -rf ${LAMBDA_BUILD_DIR}/setuptools*
	@rm -rf ${LAMBDA_BUILD_DIR}/pip*
	@rm -rf ${LAMBDA_BUILD_DIR}/pkg_resources*
	@rm -rf ${LAMBDA_BUILD_DIR}/__pycache__
	@rm -rf ${LAMBDA_BUILD_DIR}/*.dist-info
	@rm -rf ${LAMBDA_BUILD_DIR}/*.egg-info
	@rm -rf ${VIRTUAL_ENV}/
	@rm -rf env_build/
	
	@+echo $(OKGREEN)"[OK] Archivos eliminados"$(END)
	@+echo ""

zip:
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@+echo $(HEADER)"Empaquetando"$(END)
	@+echo $(HEADER)"---------------------------------------------"$(END)
	@if ! cd ${LAMBDA_BUILD_DIR} && zip -q -r ../$(PROJECT).zip .; then \
		echo $(FAIL)"[ERROR] Problema en el empaquetamiento."$(END); \
	else \
		zip -q -r ../$(PROJECT).zip . ; \
		echo $(OKGREEN)"[OK] Empaquetado finalizado"$(END); \
	fi
	@+echo ""
