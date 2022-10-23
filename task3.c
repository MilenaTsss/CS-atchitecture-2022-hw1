#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void input(int *array, int size, FILE *input_) {
    for (int i = 0; i < size; ++i) {
        fscanf(input_, "%d", &array[i]);
    }
}

void create_new_array(int *array, int *new_array, int size) {
    for (int i = 0, j = 0; i < (size + 1) / 2 && j < size; ++i, j += 2) {
        new_array[j] = array[i];
    }
    for (int i = (size + 1) / 2, j = 1; i < size && j < size; ++i, j += 2) {
        new_array[j] = array[i];
    }
}

void output(int *array, int size, FILE *output_) {
    for (int i = 0; i < size - 1; i++) {
        fprintf(output_, "%d ", array[i]);
    }
    fprintf(output_, "%d\n", array[size - 1]);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        printf("Please give input and output file");
        return 0;
    }
    FILE *input_;
    FILE *output_;
    if (strcmp(argv[1], "stdin") == 0) {
        input_ = stdin;
    } else {
        input_ = fopen(argv[1], "r");
    }

    if (strcmp(argv[2], "stdout") == 0) {
        output_ = stdout;
    } else {
        output_ = fopen(argv[2], "w");
    }

    int size;
    fscanf(input_, "%d", &size);
    int size_ = size;
    int *array = malloc(size_ * sizeof(int));
    int *new_array = malloc(size_ * sizeof(int));

    input(array, size_, input_);
    create_new_array(array, new_array, size_);
    output(new_array, size_, output_);
    free(array);
    free(new_array);
    if (strcmp(argv[1], "stdin")) {
        fclose(input_);
    }
    if (strcmp(argv[2], "stdout")) {
        fclose(output_);   
    }
    return 0;
}
