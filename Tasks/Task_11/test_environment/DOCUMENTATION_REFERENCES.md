# Documentation References for Task 11

This document contains all official documentation references gathered for verifying claims in Response 1 and Response 2.

---

## 1. Pandas Series.to_csv() Documentation

**Source:** https://pandas.pydata.org/docs/reference/api/pandas.Series.to_csv.html

### Header Parameter

**Official Documentation Excerpt:**

The `Series.to_csv()` method accepts the following parameter for `header`:

- **Type:** `Union[bool, List[str]]`
- **Default:** `True` (in modern pandas versions 1.0+)
- **Description:** If a list of strings is given it is assumed to be aliases for the column names. By specifying `header=False`, we avoid writing a header to the file.

**Key Finding:** When `header=True` is specified for a pandas Series, the Series name (or index level name if applicable) should be written as the header. However, if the Series has no name (which is the default), the behavior may vary.

---

## 2. Pandas Int64 Nullable Integer Documentation

**Source:** https://pandas.pydata.org/docs/user_guide/integer_na.html

### Official Documentation Excerpt:

**Quote from pandas documentation:**

> pandas.array() will infer a nullable-integer dtype, and the Int64 dtype is specifically designed to handle integer data with missing values.
>
> **Key Features:**
> 1. You must explicitly pass the dtype into array() or Series using either pd.Int64Dtype() or the string alias "Int64" (note the capital "I").
> 2. arrays.IntegerArray uses pandas.NA as its scalar missing value, which allows integers to represent missing data without converting to floats.
> 3. Operations involving an integer array will behave similar to NumPy arrays. Missing values will be propagated.

**Usage Examples from Documentation:**

```python
# Creating arrays with Int64 dtype
pd.array([1, None], dtype="Int64")

# Creating Series with Int64 dtype
pd.Series([1, None], dtype="Int64")
```

**Key Finding:** The Int64 dtype prevents `.0` decimal notation because it stores data as integers rather than floats. Missing values are represented as `<NA>` instead of `NaN`.

---

## 3. Pandas pd.NA Boolean Comparison Error

**Source:** https://pandas.pydata.org/docs/user_guide/missing_data.html
**Issue Tracker:** https://github.com/pandas-dev/pandas/issues/38224

### Official Documentation on pd.NA:

**Quote from pandas documentation:**

> Since the actual value of an NA is unknown, it is ambiguous to convert NA to a boolean value.

**Error Message:**
```
TypeError: boolean value of NA is ambiguous
```

**Why This Occurs:**

The error "TypeError: Boolean value of NA is ambiguous" arises when you try to evaluate a pandas object containing `pd.NA` (Not Available) values in a boolean context. Python does not know how to interpret a missing value (NA) when it expects a True or False.

**Common Scenarios:**

1. **Direct comparison with `==` or `!=`:** Using operators like `val != pd.NA` raises the error because the result of the comparison is ambiguous.

2. **Using `and`, `or` with pd.NA:** Logical operators directly with pd.NA raise the error "boolean value of NA is ambiguous".

3. **Conditional statements:** Using pd.NA in `if` statements without proper handling.

**Solutions:**

1. **Use `.isna()` or `.notna()` methods:**
   ```python
   pd.isna(val)  # Correct way to check for NA
   ```

2. **Handle NA values before operations:**
   ```python
   df.fillna(some_value)  # Replace NA before comparison
   ```

3. **Use element-wise operators for conditions:**
   ```python
   # Use & instead of 'and', | instead of 'or'
   (df['A'].notna() & (df['A'] > 1)).any()
   ```

**Key Finding:** The Response 1 code uses `val != pd.NA` which directly triggers this error. The correct approach is `pd.isna(val)` or `val is pd.NA`.

---

## 4. Python bisect.bisect_right() Documentation

**Source:** https://docs.python.org/3/library/bisect.html

### Official Documentation Excerpt:

**Function Signature:**
```python
bisect.bisect_right(a, x, lo=0, hi=len(a), *, key=None)
```

**Official Description:**

> The `bisect_right()` function is similar to `bisect_left()`, but returns an insertion point which comes after (to the right of) any existing entries of x in a.
>
> The returned insertion point `ip` partitions the array `a` into two slices such that:
> - `all(elem <= x for elem in a[lo : ip])` is true for the left slice
> - `all(elem > x for elem in a[ip : hi])` is true for the right slice

**Alias:**
> Note that `bisect.bisect()` is an alias for `bisect_right()`, so both function names can be used interchangeably.

**Use Case:**
> The `bisect_right()` method returns the right-most index to insert the given element while maintaining the sorted order.

**Example for Finding Closest Upstream Position:**

Given sorted array `[50, 120, 200, 300, 500]` and query `250`:

```python
import bisect
ref_positions = [50, 120, 200, 300, 500]
q = 250

idx = bisect.bisect_right(ref_positions, q) - 1
# bisect_right returns 3 (insertion point after 200)
# idx = 3 - 1 = 2
# ref_positions[2] = 200 ✓ (correct upstream position)
```

**Key Finding:** `bisect_right()` is the correct algorithm for finding the closest upstream (largest value ≤ query) position. The logic `bisect_right(ref_positions, q) - 1` correctly identifies the index of the largest reference position that is less than or equal to the query position.

---

## 5. Pandas to_csv() quoting Parameter

**Source:** https://pandas.pydata.org/docs/reference/api/pandas.Series.to_csv.html

### Quoting Parameter Documentation:

**Official Description:**

The `quoting` parameter controls field quoting behavior. It accepts integer constants from Python's `csv` module:

- `csv.QUOTE_MINIMAL` (0): Only quote fields containing special characters
- `csv.QUOTE_ALL` (1): Quote all fields
- `csv.QUOTE_NONNUMERIC` (2): Quote all non-numeric fields
- `csv.QUOTE_NONE` (3): Never quote fields

**Response 2 Uses:**
```python
result.to_csv(
    args.output_file,
    sep='\t',
    header=True,
    index=False,
    quoting=3  # csv.QUOTE_NONE
)
```

**Key Finding:** The `quoting=3` (csv.QUOTE_NONE) setting ensures that pandas will never add quotes around field values, regardless of content. This is appropriate for numeric-only output but can cause issues if the data contains tab characters or newlines within fields.

---

## Summary of Key Documentation Points

1. **Series.to_csv() header=True:** Should write a header line with the Series name or a default label.

2. **Int64 dtype:** Specifically designed to store integers without `.0` notation and handle missing values as `<NA>` instead of `NaN`.

3. **pd.NA comparisons:** Cannot use `!=` or `==` operators directly with pd.NA; must use `pd.isna()` or `pd.notna()` functions.

4. **bisect_right():** Correctly finds the insertion point for binary search; subtracting 1 gives the index of the largest value ≤ query.

5. **quoting=3 (QUOTE_NONE):** Disables all quoting in CSV/TSV output, suitable for clean numeric data.
