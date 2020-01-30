#include <stdio.h>
#include <stdlib.h>
#include <x86intrin.h>

typedef struct {
    int start;
    int peak;
    int len;
} result_t;

void swap(result_t *a, result_t *b) {
    result_t tmp = *a;
    *a = *b;
    *b = tmp;
}

void sorter(result_t **current_top4, result_t new_result) {
    if (current_top4[3]->peak > new_result.peak) {
        return;
    }

    int is_same = 0;
    int same_index;
    for (int i = 0; i < 4; i++) {
        if (current_top4[i]->peak == new_result.peak) {
            is_same = 1;
            same_index = i;
            break;
        }
    }

    if (is_same) {
        if (current_top4[same_index]->len < new_result.len) {
            swap(current_top4[same_index], &new_result);
        }
        return;
    }

    int idx;
    for (int i = 3; i >= 0; i--) {
        if (current_top4[i]->peak < new_result.peak) {
            idx = i;
        }
    }

    for (int i = 2; i >= idx; i--) {
        swap(current_top4[i], current_top4[i + 1]);
    }
    swap(current_top4[idx], &new_result);
}

result_t mountain_result(int start) {
    int height = start;
    int peak = height;
    int len = 0;
    while (height != 1) {
        if (height % 2 == 0) {
            height /= 2;
        } else {
            height = 3 * height + 1;
            if (height > peak) {
                peak = height;
            }
        }
        len++;
    }
    result_t ans = { start, peak, len };
    return ans;
}

void init(result_t **ans) {
    int i;
    for (i = 0; i < 4; i++) {
        ans[i] = (result_t*)malloc(sizeof(result_t));
        ans[i]->start = 0;
        ans[i]->peak = 0;
        ans[i]->len = 0;
    }
}

int main() {
    long long start = _rdtsc();

    result_t **ans;
    ans = (result_t**)malloc(4 * sizeof(result_t*));

    init(ans);

    for (int i = 0; i < 512; i++) {
        result_t r = mountain_result(2 * i + 1);
        sorter(ans, r);
    }

    long long end = _rdtsc();
    printf("It took %lld clocks\n\n", end - start);

    for (int i = 0; i < 4; i++) {
        printf("Start: %d\n     Peak: %d\n     Len:  %d\n\n", ans[i]->start, ans[i]->peak, ans[i]->len);
    }
    return 0;
}
