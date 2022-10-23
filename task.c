#include <stdio.h>

void input(int *array, int size) {
    for (int i = 0; i < size; ++i) {
        scanf("%d", &array[i]);
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

void output(int *array, int size) {
    for (int i = 0; i < size - 1; i++) {
        printf("%d ", array[i]);
    }
    printf("%d\n", array[size - 1]);
}

int main() {
    int size;
    scanf("%d", &size);
    int array[size];
    int new_array[size];

    input(array, size);
    create_new_array(array, new_array, size);
    output(new_array, size);
    return 0;
}
