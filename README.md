![Screenshot](icon/mole128.png)
Mole Pad
========

Pen-and-pencil friendly one-time-pad cipher tool. Includes integrated staggered checkerboard encoder/decoder. 

Beta release available for Linux, Mac OS and Windows (a bit quirky, but works).

![Screenshot](media/molepad_alpha_screen.png)

Disclaimer
----------

One-time-pad cipher is theoretically unbreakable, but in pratice you have to obey some rules to use it safely. And rule number one is — "There is no such thing as safe computer". Therefore, this program can be used for educational purpose only. Even in hardened environment you'd not trust it too much. 

For better understanding of subject I'd recommend Dirk Rijmenants site: http://users.telenet.be/d.rijmenants/

Features
--------

1. Many encoding tables included, plus ability to load custom one from file, and even completely omit encoding stage (if you prefer to encode/decode by hand).
1. View code table source 
2. Shows intermediate result of encryption/decryption process
3. Pen-and-pencil friendly algorithm, tested and approved by generations of spies
4. Generation of one-time pads (using /dev/random), preliminary implementation

Credits
-------

Special thanks to Dirk Rijmenants and his great site for inspiration and healthy paranoia.


