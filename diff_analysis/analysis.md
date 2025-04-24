
## 1 Code that was not executed in bloated but that is now executed in deblaoted
### Exemple 1
In grep :

```c 
DELETED_BUT_EXEC_IN_BLOATED  if (! out_quiet) {
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED    if (pending > 0) {
        {
[EXEC_in_debloted]      prpending(beg);
      }
```
We see that prpending is now executed in debloted since the conditional has been removed. 

### Exemple 2 
in grep : 
```c
EXEC_BUT_NOT_EXEC_IN_BLOATED     tmp = realloc((void *)*up, asize);
```
==> realloc not executed in bloated but done in debloated

## 2 Code that have been removed on debloated version but that was executed in bloated : potentially optimising code

### Exemple 1

In SIR sources : 

in gen_bitlen method, line 3077-3081

```C
 h --;
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED      m = heap[h];
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED      if (m > max_code) {
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED        goto while_continue___4;
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED      }
```

If we have a look on the BLOATEDginal gzip sources, the GNU source not those from the SIR bench. 

The code that have been deleted is commented with `/* In a first pass, compute the optimal bit lengths (which may
     * overflow in the case of the bit length tree).
     *`



```C
/* ===========================================================================
 * Compute the optimal bit lengths for a tree and update the total bit length
 * for the current block.
 * IN assertion: the fields freq and dad are set, heap[heap_max] and
 *    above are the tree nodes sorted by increasing frequency.
 * OUT assertions: the field len is set to the optimal bit length, the
 *     array bl_count contains the frequencies for each bit length.
 *     The length opt_len is updated; static_len is also updated if stree is
 *     not null.
 */
local void gen_bitlen(desc)
    tree_desc near *desc; /* the tree descriptor */
{
    ct_data near *tree  = desc->dyn_tree;
    int near *extra     = desc->extra_bits;
    int base            = desc->extra_base;
    int max_code        = desc->max_code;
    int max_length      = desc->max_length;
    ct_data near *stree = desc->static_tree;
    int h;              /* heap index */
    int n, m;           /* iterate over the tree elements */
    int bits;           /* bit length */
    int xbits;          /* extra bits */
    ush f;              /* frequency */
    int overflow = 0;   /* number of elements with bit length too large */

    for (bits = 0; bits <= MAX_BITS; bits++) bl_count[bits] = 0;

    /* In a first pass, compute the optimal bit lengths (which may
     * overflow in the case of the bit length tree).
     */
    tree[heap[heap_max]].Len = 0; /* root of the heap */

    for (h = heap_max+1; h < HEAP_SIZE; h++) {
        n = heap[h];
        bits = tree[tree[n].Dad].Len + 1;
        if (bits > max_length) bits = max_length, overflow++;
        tree[n].Len = (ush)bits;
        /* We overwrite tree[n].Dad which is no longer needed */

        if (n > max_code) continue; /* not a leaf node */

        bl_count[bits]++;
        xbits = 0;
        if (n >= base) xbits = extra[n-base];
        f = tree[n].Freq;
        opt_len += (ulg)f * (bits + xbits);
        if (stree) static_len += (ulg)f * (stree[n].Len + xbits);
    }
    if (overflow == 0) return;

    Trace((stderr,"\nbit length overflow\n"));
    /* This happens for example on obj2 and pic of the Calgary corpus */

    /* Find the first bit length which could increase: */
    do {
        bits = max_length-1;
        while (bl_count[bits] == 0) bits--;
        bl_count[bits]--;      /* move one leaf down the tree */
        bl_count[bits+1] += 2; /* move one overflow item as its brother */
        bl_count[max_length]--;
        /* The brother of the overflow item also moves one step up,
         * but this does not affect bl_count[max_length]
         */
        overflow -= 2;
    } while (overflow > 0);

    /* Now recompute all bit lengths, scanning in increasing frequency.
     * h is still equal to HEAP_SIZE. (It is simpler to reconstruct all
     * lengths instead of fixing only the wrong ones. This idea is taken
     * from 'ar' written by Haruhiko Okumura.)
     */
    for (bits = max_length; bits != 0; bits--) {
        n = bl_count[bits];
        while (n != 0) {
            m = heap[--h];
            if (m > max_code) continue;
            if (tree[m].Len != (unsigned) bits) {
                Trace((stderr,"code %d bits %d->%d\n", m, tree[m].Len, bits));
                opt_len += ((long)bits-(long)tree[m].Len)*(long)tree[m].Freq;
                tree[m].Len = (ush)bits;
            }
            n--;
        }
    }
}
```  



### Exemple 2 :
in ct_init method 

```C

[EXEC]DELETED_BUT_EXEC_IN_BLOATED  input_len = 0L;
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED  compressed_len = input_len;
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED  if ((int )static_dtree[0].dl.len != 0) {
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED    return;
    }
[EXEC]DELETED_BUT_EXEC_IN_BLOATED  length = 0;
    code = 0```


A block that return rapidly is removed, this block have been executed in bloated version meaning that less code have been executed 

corresponding code in gnu BLOATEDginal file :


```c
/* the arguments must not have side effects */

/* ===========================================================================
 * Allocate the match buffer, initialize the various tables and save the
 * location of the internal file attribute (ascii/binary) and method
 * (DEFLATE/STORE).
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


## Exemple 3 - free not executed 

in huft_free :

``` c
     p --;
[EXEC]DELETED_BUT_EXEC_IN_BLOATED    q = p->v.t;
 [EXEC] DELETED_BUT_EXEC_IN_BLOATED    free((void *)((char *)p))
 ```

 in gnu 
 ```c

No freeing might have impac

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

