
using Formatting

# Prints out two-dimensional array formatted as table with (optional) specified column names. Numbers in the jth column are formatted according to C-style formatting string formats[j]; can also specify single format string for all columns (default).
function printarray(array; colnames=[], usecolnames=true, format="%f", formats=[], minwidth=5, padding=3)

    I = size(array, 1); J = size(array, 2) # number of rows and columns in array

    if usecolnames
        if length(colnames) == 0
            colnames = ["col"*string(j) for j in 1:J]
        elseif length(colnames) != J
            error("Number of column names must equal number of columns in array")
        end
    end

    if length(formats) == 0
        formats = repeat([format], J)
    elseif length(formats) != J
        error("Number of formats must equal number of columns in array")
    end

    # convert each number in array to string, with specified formatting
    strarray = [sprintf1(formats[j], array[i,j]) for i in 1:I, j in 1:J]

    # determine length (in chars) of each number in array
    numlengths = [length(strarray[i,j]) for i in 1:I, j in 1:J]

    # print out row of column names
    if usecolnames
        colwidths = [max(maximum(numlengths[:,j]), length(colnames[j]), minwidth) for j in 1:J] # determine width of each column (in chars); must be at least as wide as numbers in column and colname
        [print(" "^(colwidths[j]-length(colnames[j])) * colnames[j] * " "^padding) for j in 1:J]
        println("\n" * "-"^(sum(colwidths) + padding*(J-1)))
    else
        colwidths = [max(maximum(numlengths[:,j]), minwidth) for j in 1:J]
    end
    
    # print out array values row by row
    for i in 1:I
        [print(" "^(colwidths[j]-numlengths[i,j]) * strarray[i,j] * " "^padding) for j in 1:J]
        print("\n")
    end    
end
