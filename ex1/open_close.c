#include <stdio.h>
#include <unistd.h>

int main() {
  FILE *a, *b, *c;

  a = fopen("a", "r");
  b = fopen("b", "r");
  sleep(3);
  fclose(b);
  sleep(1);
  c = fopen("c", "r");
  fclose(c);
  fclose(a);

  return 0;
}
