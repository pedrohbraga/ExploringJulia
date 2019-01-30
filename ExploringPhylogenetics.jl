# Author: Pedro Henrique Pereira Braga
# Date: 2019-01-25

# Add packages using Pkg.add("PackageName")
Pkg.add("Diversity")
Pkg.add("Phylo")
Pkg.add("SpatialEcology")
Pkg.add("Plots")
Pkg.add("JLD2")
Pkg.add("SparseArrays")
Pkg.add("DataFrames")
Pkg.add("Clustering")
Pkg.add("Distances")

# Load packages running
# using PackageName
using Diversity, Phylo
using SpatialEcology
using Plots
# You can load multiple pkgs separating them by commas
using JLD2, SparseArrays, DataFrames
using Distances

# Set working directory by: cd("../mydir/someotherdir/")

cd("C:\\Users\\phper\\Documents\\GitHub\\pedrohbraga\\ExploringJulia")

# Creating species
species = ["Dog", "Cat", "Human", "Monkey", "Alien"];

# Creating communities
communities = DataFrame(Dog = [1, 1, 1],
                        Cat = [0, 1, 1],
                        Human = [1, 0, 0],
                        Monkey = [1, 0, 1],
                        Alien = [0, 0, 1])
communities

# Get column names for the communitiesDataFrame
names(communities)

# Create a random phylogenetic tree on species
nt = rand(Nonultrametric(species))
nt

# Allows you to see the branch length information
collect(getbranches(nt))
getbranches(nt)

# Create a metaphylo object
# Before, since metaphylo works with Arrays, I had to convert communities to SparseArrays
communitiesArray = convert(Array, communities)
# metaphylo puts species in rows and sites in columns. Therefore, I needed to
# use the ' conjugate transpose operator
communitiesArray = communitiesArray'

# Using the stack and unstack functions from DataFrame, I was able to do the Same
# In summary, this creates an id column:
communities[:id] = 1:size(communities, 1)

# Stacks the information in a sort of long format
communitiesStack = stack(communities, names(communities)[1:length(names(communities))-1])
communitiesStack

# Unstack the stacked data frame, to then obtain a transposed one
communitiesUnstack = unstack(communitiesStack, :variable, :id, :value)

# Converts it to an Array, also taking away the id row
communitiesArray = convert(Array, communitiesUnstack[:,2:size(communitiesUnstack)[2]])

# Finally, create the Metaphylo object
metaphylo = Metacommunity(communitiesArray, PhyloTypes(nt));

# One can access what is inside the metaphylo object like This
?metaphylo
metaphylo.types # Returns the PhyloTypes within it
metaphylo.rawabundances # The raw community data
metaphylo.rawabundances

# Returns the names of the tips of the phylogeny
leafnames = gettypenames(metaphylo, true)
# Same as "getleafnames(nt)"

# Calculates gamma diversity
meta_gamma(metaphylo, 0)

# Can I calculate pairwise distances on the phylogeny?
?pairwise
distances(nt) # This seems to work!
