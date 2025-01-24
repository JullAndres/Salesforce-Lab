# SFDC Developer Write-Up Lab
Este repositorio contiene soluciones a retos, super badges, PoC en el mundo Salesforce


## Tabla de contenido

-   [Instalación ](#Instalación): Instalación y entrega

## Instalación

1. Requisitos

    - Enable Dev Hub en el Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

1. Autenticarse en el Trailhead Playground

    ```
    sf org login web -d -a myhuborg
    ```

1. Clone el repo:

    ```
    git clone https://github.com/JullAndres/Salesforce-Lab.git
    cd Salesforce-Lab

    ```

1. Crear a scratch org: 

    ```
    sf org create scratch -d -f config/project-scratch-def.json -a global
    ```

1. Despliega los cambios desde tu repositorio local al Scratch Org:

    ```
    sf project deploy start
    ```

1. Asignacion de permisos:

    ```
    sf org assign permset -n {permissionSet}
    ```

1. Importar datos:

    ```
    sf data tree import -p ./data/data-plan.json
    ```

1. Abre la scratch org:

    ```
    sf org open
    ``` 