#include <stdio.h>
#include <stdlib.h>

void input(register int *array, register int size) {
    for (register int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
    }
}

void create_new_array(register int *array, register int *new_array, register int size) {
    for (register int i = 0, j = 0; i < (size + 1) / 2 && j < size; ++i, j += 2) {
        new_array[j] = array[i];
    }

    for (register int i = (size + 1) / 2, j = 1; i < size && j < size; ++i, j += 2) {
        new_array[j] = array[i];
    }
}

void output(register int *array, register int size) {
    for (register int i = 0; i < size - 1; i++) {
        printf("%d ", array[i]);
    }
    printf("%d\n", array[size - 1]);
}

int main() {
    int size;
    scanf("%d", &size);
    register int size_ = size;
    register int *array = malloc(size_ * sizeof(int));
    register int *new_array = malloc(size_ * sizeof(int));

    input(array, size_);
    create_new_array(array, new_array, size_);
    output(new_array, size_);
    free(array);
    free(new_array);
    return 0;
}
