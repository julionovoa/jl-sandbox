using Plots, Colors, FileIO
using EarthEngine

Initialize()

# using Julia
dem = EE.Image("USGS/SRTMGL1_003")
xy = Point(86.9250, 27.9881)
value = get(first(sample(dem, xy, 30)), "elevation")
println(getInfo(value))

# using Python API
dem = ee.Image("USGS/SRTMGL1_003");
xy = ee.Geometry.Point(86.9250, 27.9881);
value = dem.sample(xy,scale=30).first().get("elevation")
println(value.getInfo())

# plotting some data
img = EE.Image("LANDSAT/LT05/C01/T1_SR/LT05_034033_20000913")
band_names = EE.List(["B3", "B4"])
samples_fc = sample(divide(select(img, band_names), 10000); scale=30, numPixels=500)
reducer = repeat(toList(EE.Reducer()), length(band_names))
sample_cols =  reduceColumns(samples_fc, reducer, band_names)
sample_data = getInfo(get(sample_cols, "list"))

theme(:bright)
scatter(sample_data[1,:], sample_data[2,:], markersize=4, alpha=0.6, xlabel="Red", ylabel="NIR", leg=false)

# image visualization
function ndvi(img::EE.Image)
    return normalizedDifference(img, ["B4", "B3"])
end

ndvi_img = ndvi(img)

color_map = map(x -> hex(x,:RRGGBB), cgrad(:Greens_9));

thumburl = getThumbUrl(
    ndvi_img,
    Dict(
        "min" => 0,
        "max" => 0.8,
        "dimensions" => 1024,
        "palette" => color_map,
        "format" => "png",
    )
)
localpath = download(thumburl)

png = FileIO.load(localpath);

plot(png, ticks = nothing, border = :none)

# define a function that expects an EE.Image as input and returns EE.Image
function ndvi(img::EE.Image)
    return normalizedDifference(img, ["B5","B4"])
end

# get an Image and calculate a FeatureCollection
img = EE.Image("LANDSAT/LC08/C01/T1_TOA/LC08_033032_20170719")
fc = sample(img;scale=30,numPixels=500)

# works
ndvi(img) 