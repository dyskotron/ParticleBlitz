#Particle Blitz

Particle engine based on bitmap blitting.

##The Engine
I Created base of this engine when i needed simple snowing animation for one game based on display list where i could not use Starling or anything else based on Stage3D. I needed lot of particles and it would be quite cpu hungry when it will be done with DisplayObjects so i decided to use bitmap blitting.

###draw() or copyPixels() ?
First thing i had to decide was if i should use BimapData's draw() method or copyPixels(). I was quite shure performance will be better with copyPixels() but at cost of additional features this method provides, mainly transformMatrix which u can use for scaling and rotating, but also color transform and blendMode would be handy. But after couple of tests it was pretty clear i have to go with copyPixels() because in some scenarios it was 5 times faster or even more. Problem is that method does not provide anything to scale or rotate given IBitmapDataDrawable object.

###So?
Solution is quite simple if you can sacrifice a some memory and in this case it really pays if you consider what you can save on CPU. I just created one big Bitmap Where is given DisplayObject in given count of rotation this happens in X axis of this generated sprite sheet, In Y axis there copies of this display object with rotations, but in different scales, and they are again here for all rotations.
When i finally draw the data to main bitmap copyPixels let me specify destination in given Bitmap, source bitmap but also rectangle which tells the method which part of source bitmap it should use, Using this its easy to pick part of prerendered sprite sheet which represents the DisplayObject for given rotation and size. 

###Alpha
But we wanted also Alpha animation right? No problem. as copyPixels() have two additional arguments, alphaBitmapData and alphaPoint, which are simlar to source bitmap and rectangle but it takes just alpha information from that bitmap, also as we provided sourceRect with given width and height, alphaBitmap need just Point instead od rectangle because with and height is taken from sourceRect and we just need to know x & y where to take alpha data. That means i just can generate alpha sheet similary to main sprite sheet, but it just sequence of squares with different alpha.

###MovieClip support
when adding this particle editor to another place in the game, the graphic guys wanted to use 3D looking object a bit rotated in 3D space where 2D rotation would be awkward, so they prepared me a MovieClip they wanted and added support for it, It works exactly same like with any other DisplayObjects but instead of rotating DicplayObjects my self, i just render all frames of movie clip in X axis of the sprite sheet.

##Editor
Engine is done, so whats next? Editing actual particle effect is quite painfull process as you have to recompile every time you changed some values. And as this particle engine was used on more places in the game and we had to always go thru this with the graphic guys it was pretty clear i have to do a simple Editor, Its done with minimal comps which are great for prototyping as its realy quick and easy to set up, they are not so great for final product(and thats not even what their author intended) but the engine itself is completely separated from the editor and in the actual game when its used there are just engine classes used, so i went with minimal comps.

##Next Steps

###Engine
I would like to add couple of particle properties like start and end values for alpha and size and their variance, also like to add color tint of display object and its animation and instead of bunch of public properties i would initialize engine with some ValueObject defining all properties of particle effect. Other nice thing would be add different kind of emmiters, for example radial one.

###Editor
It is definitely far from final thing, there are even some properties that you can set from code but they're not available from editor, and some controls i would definitely do differently after using the editor couple of times, but it works. From architecture point of view i dont like how editor is directly checking all UI components and then passing all values to the engine, instead of this i would let editor create and change ValueObject with settings i was talking about in Engine paragraph above. After that i would definitely add option to save theese setting as a file, it could be binary, json or xml and it this case i would not mind bigger size in exchange for human readible and editable format.









