```c
    int mmask = -1 << (w-1);
    mask &= (-1 + !(mmask&x));
```

