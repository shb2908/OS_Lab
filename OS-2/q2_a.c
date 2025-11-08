#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>

/* Constants */
#define NUM_ITERATIONS 10
#define MAX_SLEEP_TIME 5
#define PROCESS_X "X"
#define PROCESS_Y "Y"

/* Function prototypes */
void run_child_process(const char* process_name);
int create_processes(void);
void handle_fork_error(void);

/**
 * Executes the iterations for a child process
 * @param process_name Name identifier for the process
 */
void run_child_process(const char* process_name) {
    for (int i = 0; i < NUM_ITERATIONS; i++) {
        printf("Process %s(%d) is at iteration %d\n", 
               process_name, getpid(), i + 1);
        
        int sleep_time = rand() % MAX_SLEEP_TIME + 1;
        sleep(sleep_time);
    }
    exit(EXIT_SUCCESS);
}

/**
 * Handles fork error by printing error message
 */
void handle_fork_error(void) {
    perror("Fork failed");
    exit(EXIT_FAILURE);
}

/**
 * Creates two child processes and manages their execution
 * @return EXIT_SUCCESS on successful execution
 */
int create_processes(void) {
    pid_t pid_x, pid_y;

    // Initialize random seed
    srand(time(NULL));

    // Create first child process (X)
    pid_x = fork();
    if (pid_x < 0) {
        handle_fork_error();
    } else if (pid_x == 0) {
        run_child_process(PROCESS_X);
    }

    // Create second child process (Y)
    pid_y = fork();
    if (pid_y < 0) {
        handle_fork_error();
    } else if (pid_y == 0) {
        run_child_process(PROCESS_Y);
    }

    // Parent process waits for both children to complete
    if (pid_x > 0 && pid_y > 0) {
        wait(NULL);
        wait(NULL);
    }

    return EXIT_SUCCESS;
}

/**
 * Main function - entry point of the program
 * @return EXIT_SUCCESS on successful execution
 */
int main(void) {
    return create_processes();
}