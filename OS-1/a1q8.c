#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define MAX_INPUT_SIZE 1024
#define MAX_ARGS 64

// Function to parse the command line input
void parse_input(char *input, char **args) {
    char *token = strtok(input, " \n");
    int i = 0;
    while (token != NULL && i < MAX_ARGS - 1) {
        args[i++] = token;
        token = strtok(NULL, " \n");
    }
    args[i] = NULL;
}

// Function to execute the command
void execute_command(char **args) {
    if (args[0] == NULL) {
        return;
    }

    if (strcmp(args[0], "cd") == 0) {
        if (args[1] == NULL) {
            fprintf(stderr, "Expected argument to \"cd\"\n");
        } else {
            if (chdir(args[1]) != 0) {
                perror("cd");
            }
        }
    } else if (strcmp(args[0], "pwd") == 0) {
        char cwd[1024];
        if (getcwd(cwd, sizeof(cwd)) != NULL) {
            printf("%s\n", cwd);
        } else {
            perror("getcwd");
        }
    } else {
        pid_t pid = fork();

        if (pid == 0) {
            // Child process
            if (execvp(args[0], args) == -1) {
                perror("execvp");
            }
            exit(EXIT_FAILURE);
        } else if (pid < 0) {
            // Error forking
            perror("fork");
        } else {
            // Parent process
            int status;
            waitpid(pid, &status, WUNTRACED);
        }
    }
}

int main() {
    char input[MAX_INPUT_SIZE];
    char *args[MAX_ARGS];

    while (1) {
        printf("xxxx-shell> ");
        if (fgets(input, sizeof(input), stdin) == NULL) {
            break;
        }

        parse_input(input, args);
        execute_command(args);

        if (strcmp(args[0], "exit") == 0) {
            break;
        }
    }

    return 0;
}
