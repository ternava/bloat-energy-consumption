This document discusses several code snippets identified by a differential analysis of coverage for grep-2.4.2 and gzip-1.3, compared to their debloated counterparts produced by Chisel. Our aim is to explore the reasons behind the observed increase in energy consumption induced by feature reduction. The snippets below illustrate optimized code that Chisel removed.


### Snippet 1 conditional deletion causing extra function call
In grep :

```c 
[DELETED_BUT_EXEC_IN_BLOATED]  if (! out_quiet) {
[EXEC_IN_BLOATED] DELETED_BUT_EXEC_IN_BLOATED    if (pending > 0) {
        {
[EXEC_IN_DEBLOATED]      prpending(beg);
      }
```
prpending is now executed 76 times ([cf coverage report, line 1249](./grep-2.4.2/chisel_grep-2.4.2_p0.2train.c.gcov)) in debloted since the conditional has been removed. 

Note that the prpending function also performs the (pending > 0) check; thus, the primary overhead is the extra function call.

### Snippet 2  - conditional deletion causing extra realloc
In grep : 

```c
[EXEC_IN_ORI_BUT DELETED_IN_DEBLOATED]  if (size <= asize) {    
[EXEC_IN_ORI_BUT DELETED_IN_DEBLOATED]    if (*up) {
        {
[EXEC_IN_DEBLOATED]     tmp = realloc((void *)*up, asize);
```

==> realloc not executed in bloated but done in debloated

If we have a look on the coverage report, the realloc is now executed 3 times.

### Snippet 3 - deleted early return :

in ct_init method , in [annotated_gzip](./result/annotated_gzip-1.3.c) line 2676
```C

[DELETED_BUT_EXEC_IN_BLOATED]  input_len = 0L;
[DELETED_BUT_EXEC_IN_BLOATED]  compressed_len = input_len;
[DELETED_BUT_EXEC_IN_BLOATED]  if ((int )static_dtree[0].dl.len != 0) {
[DELETED_BUT_EXEC_IN_BLOATED]    return;
    }
[DELETED_BUT_EXEC_IN_BLOATED]  length = 0;
    code = 0
```
We observe the deletion of a ealry return in the init function. 

It worth to note that this condition has never been fulfield in the bloated version. However the deletion of such code, might result in unecessary execution for other execution scenario. 

```c
IN original version , not SIR :
 */
void ct_init(attr, methodp)
    ush  *attr;   /* pointer to internal file attribute */
    int  *methodp; /* pointer to compression method */
{
    int n;        /* iterates over tree elements */
    int bits;     /* bit counter */
    int length;   /* length value */
    int code;     /* code value */
    int dist;     /* distance index */

    file_type = attr;
    file_method = methodp;
    compressed_len = input_len = 0L;

    if (static_dtree[0].Len != 0) return; /* ct_init already called */

    /* Initialize the mapping length (0..255) -> length code (0..28) */
    length = 0;
    for (code = 0; code < LENGTH_CODES-1; code++) {
        base_length[code] = length;
        for (n = 0; n < (1<<extra_lbits[code]); n++) {
            length_code[length++] = (uch)code;
        }
    }
```

## Snippet 5 - free not executed 

in huft_free :

``` c
     p --;
[DELETED_BUT_EXEC_IN_BLOATED]    q = p->v.t;
[EDELETED_BUT_EXEC_IN_BLOATED]    free((void *)((char *)p))
 ```

 in gnu original version, not SIR
 ```c

int huft_free(t)
struct huft *t;         /* table to free */
/* Free the malloc'ed tables built by huft_build(), which makes a linked
   list of the tables it made, with the links in a dummy first entry of
   each table. */
{
  register struct huft *p, *q;


  /* Go through linked list, freeing from the malloced (t[-1]) address. */
  p = t;
  while (p != (struct huft *)NULL)
  {
    q = (--p)->v.t;
    free(p);
    p = q;
  }
  return 0;
}```

