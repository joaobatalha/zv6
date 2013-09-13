ZV6: A Fork of MIT's XV6, inspired by ZFS
===

Final project for [MIT's Operating System Engineering class](http://pdos.csail.mit.edu/6.828). The project goal was to modify the [XV6](http://pdos.csail.mit.edu/6.828/2012/xv6.html) operating system (itself based on Unix V6) to support ZFS-like file systems features. Namely, we modified XV6 to suport inode-checksums and 'ditto blocks' to replace corrupted files on the spot. 

Overview
--------

The major concept that we borrowed from ZFS is that of ditto blocks. A ditto block is a mirror of a file's inode that points to a new set of data blocks that duplicate the original file's content exactly. In our system, each inode has either 0, 1, or 2 ditto blocks. We added child1 and child2 fields to the inode which point to the ditto blocks for a given file.

To determine if a file is corrupted, we implemented a checksum function that takes an inode as an argument. The checksum function iterates over every data block in a file and computes a value that is then stored in the inode and dinode. Then, to determine if a file is corrupted, the checksum is recomputed then compared against the stored value. When attempting to access a file, the ilock operation performs this check. If a file is determined to be corrupted, we attempt to find an uncorrupted version in the ditto blocks. If we find an uncorrupted version, this version propagates to the original inode (and potentially other ditto block) to restore the file. If the file cannot be recovered, the ilock operation will fail with an error code indicating the file to be corrupted.

In order to protect a high proportion of the file system, we automatically protect nodes closer to the root of the file system. Directories within 3 levels of the root are automatically protected with two ditto blocks. Directories within 6 levels of the root are automatically protected with one ditto block. 

ZFS
---

If you are curious to learn more about the awesomeness of ZFS here are a few good places to start:

- [ZFS presentation](http://wiki.illumos.org/download/attachments/1146951/zfs_last.pdf) by Jeff Bonwick and Bill Moore
- [ZFS overview](http://wiki.lustre.org/images/4/49/Beijing-2010.2-ZFS_overview_3.1_Dilger.pdf) by Andreas Dilger




