
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 0b 34 10 80       	mov    $0x8010340b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 dc 7f 10 80       	push   $0x80107fdc
80100042:	68 60 c6 10 80       	push   $0x8010c660
80100047:	e8 1a 4b 00 00       	call   80104b66 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100056:	db 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
80100060:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 db 10 80       	mov    $0x8010db84,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	c9                   	leave  
801000b1:	c3                   	ret    

801000b2 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b2:	55                   	push   %ebp
801000b3:	89 e5                	mov    %esp,%ebp
801000b5:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b8:	83 ec 0c             	sub    $0xc,%esp
801000bb:	68 60 c6 10 80       	push   $0x8010c660
801000c0:	e8 c2 4a 00 00       	call   80104b87 <acquire>
801000c5:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c8:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d0:	eb 67                	jmp    80100139 <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d5:	8b 40 04             	mov    0x4(%eax),%eax
801000d8:	3b 45 08             	cmp    0x8(%ebp),%eax
801000db:	75 53                	jne    80100130 <bget+0x7e>
801000dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e0:	8b 40 08             	mov    0x8(%eax),%eax
801000e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e6:	75 48                	jne    80100130 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000eb:	8b 00                	mov    (%eax),%eax
801000ed:	83 e0 01             	and    $0x1,%eax
801000f0:	85 c0                	test   %eax,%eax
801000f2:	75 27                	jne    8010011b <bget+0x69>
        b->flags |= B_BUSY;
801000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f7:	8b 00                	mov    (%eax),%eax
801000f9:	89 c2                	mov    %eax,%edx
801000fb:	83 ca 01             	or     $0x1,%edx
801000fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100101:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100103:	83 ec 0c             	sub    $0xc,%esp
80100106:	68 60 c6 10 80       	push   $0x8010c660
8010010b:	e8 dd 4a 00 00       	call   80104bed <release>
80100110:	83 c4 10             	add    $0x10,%esp
        return b;
80100113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100116:	e9 98 00 00 00       	jmp    801001b3 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011b:	83 ec 08             	sub    $0x8,%esp
8010011e:	68 60 c6 10 80       	push   $0x8010c660
80100123:	ff 75 f4             	pushl  -0xc(%ebp)
80100126:	e8 59 47 00 00       	call   80104884 <sleep>
8010012b:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012e:	eb 98                	jmp    801000c8 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100130:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100133:	8b 40 10             	mov    0x10(%eax),%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100140:	75 90                	jne    801000d2 <bget+0x20>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100142:	a1 90 db 10 80       	mov    0x8010db90,%eax
80100147:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014a:	eb 51                	jmp    8010019d <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014f:	8b 00                	mov    (%eax),%eax
80100151:	83 e0 01             	and    $0x1,%eax
80100154:	85 c0                	test   %eax,%eax
80100156:	75 3c                	jne    80100194 <bget+0xe2>
80100158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015b:	8b 00                	mov    (%eax),%eax
8010015d:	83 e0 04             	and    $0x4,%eax
80100160:	85 c0                	test   %eax,%eax
80100162:	75 30                	jne    80100194 <bget+0xe2>
      b->dev = dev;
80100164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100167:	8b 55 08             	mov    0x8(%ebp),%edx
8010016a:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100170:	8b 55 0c             	mov    0xc(%ebp),%edx
80100173:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100176:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100179:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017f:	83 ec 0c             	sub    $0xc,%esp
80100182:	68 60 c6 10 80       	push   $0x8010c660
80100187:	e8 61 4a 00 00       	call   80104bed <release>
8010018c:	83 c4 10             	add    $0x10,%esp
      return b;
8010018f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100192:	eb 1f                	jmp    801001b3 <bget+0x101>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100194:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100197:	8b 40 0c             	mov    0xc(%eax),%eax
8010019a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019d:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801001a4:	75 a6                	jne    8010014c <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a6:	83 ec 0c             	sub    $0xc,%esp
801001a9:	68 e3 7f 10 80       	push   $0x80107fe3
801001ae:	e8 ac 03 00 00       	call   8010055f <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bb:	83 ec 08             	sub    $0x8,%esp
801001be:	ff 75 0c             	pushl  0xc(%ebp)
801001c1:	ff 75 08             	pushl  0x8(%ebp)
801001c4:	e8 e9 fe ff ff       	call   801000b2 <bget>
801001c9:	83 c4 10             	add    $0x10,%esp
801001cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d2:	8b 00                	mov    (%eax),%eax
801001d4:	83 e0 02             	and    $0x2,%eax
801001d7:	85 c0                	test   %eax,%eax
801001d9:	75 0e                	jne    801001e9 <bread+0x34>
    iderw(b);
801001db:	83 ec 0c             	sub    $0xc,%esp
801001de:	ff 75 f4             	pushl  -0xc(%ebp)
801001e1:	e8 0d 26 00 00       	call   801027f3 <iderw>
801001e6:	83 c4 10             	add    $0x10,%esp
  return b;
801001e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ec:	c9                   	leave  
801001ed:	c3                   	ret    

801001ee <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ee:	55                   	push   %ebp
801001ef:	89 e5                	mov    %esp,%ebp
801001f1:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f4:	8b 45 08             	mov    0x8(%ebp),%eax
801001f7:	8b 00                	mov    (%eax),%eax
801001f9:	83 e0 01             	and    $0x1,%eax
801001fc:	85 c0                	test   %eax,%eax
801001fe:	75 0d                	jne    8010020d <bwrite+0x1f>
    panic("bwrite");
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	68 f4 7f 10 80       	push   $0x80107ff4
80100208:	e8 52 03 00 00       	call   8010055f <panic>
  b->flags |= B_DIRTY;
8010020d:	8b 45 08             	mov    0x8(%ebp),%eax
80100210:	8b 00                	mov    (%eax),%eax
80100212:	89 c2                	mov    %eax,%edx
80100214:	83 ca 04             	or     $0x4,%edx
80100217:	8b 45 08             	mov    0x8(%ebp),%eax
8010021a:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021c:	83 ec 0c             	sub    $0xc,%esp
8010021f:	ff 75 08             	pushl  0x8(%ebp)
80100222:	e8 cc 25 00 00       	call   801027f3 <iderw>
80100227:	83 c4 10             	add    $0x10,%esp
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	8b 00                	mov    (%eax),%eax
80100237:	83 e0 01             	and    $0x1,%eax
8010023a:	85 c0                	test   %eax,%eax
8010023c:	75 0d                	jne    8010024b <brelse+0x1f>
    panic("brelse");
8010023e:	83 ec 0c             	sub    $0xc,%esp
80100241:	68 fb 7f 10 80       	push   $0x80107ffb
80100246:	e8 14 03 00 00       	call   8010055f <panic>

  acquire(&bcache.lock);
8010024b:	83 ec 0c             	sub    $0xc,%esp
8010024e:	68 60 c6 10 80       	push   $0x8010c660
80100253:	e8 2f 49 00 00       	call   80104b87 <acquire>
80100258:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025b:	8b 45 08             	mov    0x8(%ebp),%eax
8010025e:	8b 40 10             	mov    0x10(%eax),%eax
80100261:	8b 55 08             	mov    0x8(%ebp),%edx
80100264:	8b 52 0c             	mov    0xc(%edx),%edx
80100267:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 0c             	mov    0xc(%eax),%eax
80100270:	8b 55 08             	mov    0x8(%ebp),%edx
80100273:	8b 52 10             	mov    0x10(%edx),%edx
80100276:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100279:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
8010027f:	8b 45 08             	mov    0x8(%ebp),%eax
80100282:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100285:	8b 45 08             	mov    0x8(%ebp),%eax
80100288:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
8010028f:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100294:	8b 55 08             	mov    0x8(%ebp),%edx
80100297:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029a:	8b 45 08             	mov    0x8(%ebp),%eax
8010029d:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
801002a2:	8b 45 08             	mov    0x8(%ebp),%eax
801002a5:	8b 00                	mov    (%eax),%eax
801002a7:	89 c2                	mov    %eax,%edx
801002a9:	83 e2 fe             	and    $0xfffffffe,%edx
801002ac:	8b 45 08             	mov    0x8(%ebp),%eax
801002af:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b1:	83 ec 0c             	sub    $0xc,%esp
801002b4:	ff 75 08             	pushl  0x8(%ebp)
801002b7:	e8 b2 46 00 00       	call   8010496e <wakeup>
801002bc:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002bf:	83 ec 0c             	sub    $0xc,%esp
801002c2:	68 60 c6 10 80       	push   $0x8010c660
801002c7:	e8 21 49 00 00       	call   80104bed <release>
801002cc:	83 c4 10             	add    $0x10,%esp
}
801002cf:	c9                   	leave  
801002d0:	c3                   	ret    
801002d1:	00 00                	add    %al,(%eax)
	...

801002d4 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	53                   	push   %ebx
801002d8:	83 ec 18             	sub    $0x18,%esp
801002db:	8b 45 08             	mov    0x8(%ebp),%eax
801002de:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801002e5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
801002e9:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
801002ed:	ec                   	in     (%dx),%al
801002ee:	88 c3                	mov    %al,%bl
801002f0:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002f3:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002f6:	83 c4 18             	add    $0x18,%esp
801002f9:	5b                   	pop    %ebx
801002fa:	c9                   	leave  
801002fb:	c3                   	ret    

801002fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002fc:	55                   	push   %ebp
801002fd:	89 e5                	mov    %esp,%ebp
801002ff:	83 ec 08             	sub    $0x8,%esp
80100302:	8b 45 08             	mov    0x8(%ebp),%eax
80100305:	8b 55 0c             	mov    0xc(%ebp),%edx
80100308:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010030c:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010030f:	8a 45 f8             	mov    -0x8(%ebp),%al
80100312:	8b 55 fc             	mov    -0x4(%ebp),%edx
80100315:	ee                   	out    %al,(%dx)
}
80100316:	c9                   	leave  
80100317:	c3                   	ret    

80100318 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100318:	55                   	push   %ebp
80100319:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010031b:	fa                   	cli    
}
8010031c:	c9                   	leave  
8010031d:	c3                   	ret    

8010031e <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010031e:	55                   	push   %ebp
8010031f:	89 e5                	mov    %esp,%ebp
80100321:	83 ec 38             	sub    $0x38,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100324:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100328:	74 19                	je     80100343 <printint+0x25>
8010032a:	8b 45 08             	mov    0x8(%ebp),%eax
8010032d:	c1 e8 1f             	shr    $0x1f,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x25>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x2b>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f1                	div    %ecx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	8a 90 04 90 10 80    	mov    -0x7fef6ffc(%eax),%dl
80100365:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100368:	03 45 f4             	add    -0xc(%ebp),%eax
8010036b:	88 10                	mov    %dl,(%eax)
8010036d:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100370:	8b 45 0c             	mov    0xc(%ebp),%eax
80100373:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 75 d4             	divl   -0x2c(%ebp)
80100381:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100388:	75 c6                	jne    80100350 <printint+0x32>

  if(sign)
8010038a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038e:	74 25                	je     801003b5 <printint+0x97>
    buf[i++] = '-';
80100390:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100393:	03 45 f4             	add    -0xc(%ebp),%eax
80100396:	c6 00 2d             	movb   $0x2d,(%eax)
80100399:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010039c:	eb 17                	jmp    801003b5 <printint+0x97>
    consputc(buf[i]);
8010039e:	8d 45 e0             	lea    -0x20(%ebp),%eax
801003a1:	03 45 f4             	add    -0xc(%ebp),%eax
801003a4:	8a 00                	mov    (%eax),%al
801003a6:	0f be c0             	movsbl %al,%eax
801003a9:	83 ec 0c             	sub    $0xc,%esp
801003ac:	50                   	push   %eax
801003ad:	e8 a5 03 00 00       	call   80100757 <consputc>
801003b2:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b5:	ff 4d f4             	decl   -0xc(%ebp)
801003b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bc:	79 e0                	jns    8010039e <printint+0x80>
    consputc(buf[i]);
}
801003be:	c9                   	leave  
801003bf:	c3                   	ret    

801003c0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c6:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d2:	74 10                	je     801003e4 <cprintf+0x24>
    acquire(&cons.lock);
801003d4:	83 ec 0c             	sub    $0xc,%esp
801003d7:	68 c0 b5 10 80       	push   $0x8010b5c0
801003dc:	e8 a6 47 00 00       	call   80104b87 <acquire>
801003e1:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e4:	8b 45 08             	mov    0x8(%ebp),%eax
801003e7:	85 c0                	test   %eax,%eax
801003e9:	75 0d                	jne    801003f8 <cprintf+0x38>
    panic("null fmt");
801003eb:	83 ec 0c             	sub    $0xc,%esp
801003ee:	68 02 80 10 80       	push   $0x80108002
801003f3:	e8 67 01 00 00       	call   8010055f <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f8:	8d 45 08             	lea    0x8(%ebp),%eax
801003fb:	83 c0 04             	add    $0x4,%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 17 01 00 00       	jmp    80100524 <cprintf+0x164>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 13                	je     80100426 <cprintf+0x66>
      consputc(c);
80100413:	83 ec 0c             	sub    $0xc,%esp
80100416:	ff 75 e4             	pushl  -0x1c(%ebp)
80100419:	e8 39 03 00 00       	call   80100757 <consputc>
8010041e:	83 c4 10             	add    $0x10,%esp
      continue;
80100421:	e9 fb 00 00 00       	jmp    80100521 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100426:	8b 55 08             	mov    0x8(%ebp),%edx
80100429:	ff 45 f4             	incl   -0xc(%ebp)
8010042c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042f:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100432:	8a 00                	mov    (%eax),%al
80100434:	0f be c0             	movsbl %al,%eax
80100437:	25 ff 00 00 00       	and    $0xff,%eax
8010043c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100443:	0f 84 fd 00 00 00    	je     80100546 <cprintf+0x186>
      break;
    switch(c){
80100449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044c:	83 f8 70             	cmp    $0x70,%eax
8010044f:	74 45                	je     80100496 <cprintf+0xd6>
80100451:	83 f8 70             	cmp    $0x70,%eax
80100454:	7f 13                	jg     80100469 <cprintf+0xa9>
80100456:	83 f8 25             	cmp    $0x25,%eax
80100459:	0f 84 97 00 00 00    	je     801004f6 <cprintf+0x136>
8010045f:	83 f8 64             	cmp    $0x64,%eax
80100462:	74 14                	je     80100478 <cprintf+0xb8>
80100464:	e9 9c 00 00 00       	jmp    80100505 <cprintf+0x145>
80100469:	83 f8 73             	cmp    $0x73,%eax
8010046c:	74 43                	je     801004b1 <cprintf+0xf1>
8010046e:	83 f8 78             	cmp    $0x78,%eax
80100471:	74 23                	je     80100496 <cprintf+0xd6>
80100473:	e9 8d 00 00 00       	jmp    80100505 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100478:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047b:	8b 00                	mov    (%eax),%eax
8010047d:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 90 fe ff ff       	call   8010031e <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8b 00 00 00       	jmp    80100521 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8b 00                	mov    (%eax),%eax
8010049b:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010049f:	83 ec 04             	sub    $0x4,%esp
801004a2:	6a 00                	push   $0x0
801004a4:	6a 10                	push   $0x10
801004a6:	50                   	push   %eax
801004a7:	e8 72 fe ff ff       	call   8010031e <printint>
801004ac:	83 c4 10             	add    $0x10,%esp
      break;
801004af:	eb 70                	jmp    80100521 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b4:	8b 00                	mov    (%eax),%eax
801004b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004bd:	0f 94 c0             	sete   %al
801004c0:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004c4:	84 c0                	test   %al,%al
801004c6:	74 22                	je     801004ea <cprintf+0x12a>
        s = "(null)";
801004c8:	c7 45 ec 0b 80 10 80 	movl   $0x8010800b,-0x14(%ebp)
      for(; *s; s++)
801004cf:	eb 1a                	jmp    801004eb <cprintf+0x12b>
        consputc(*s);
801004d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d4:	8a 00                	mov    (%eax),%al
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 75 02 00 00       	call   80100757 <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	ff 45 ec             	incl   -0x14(%ebp)
801004e8:	eb 01                	jmp    801004eb <cprintf+0x12b>
801004ea:	90                   	nop
801004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ee:	8a 00                	mov    (%eax),%al
801004f0:	84 c0                	test   %al,%al
801004f2:	75 dd                	jne    801004d1 <cprintf+0x111>
        consputc(*s);
      break;
801004f4:	eb 2b                	jmp    80100521 <cprintf+0x161>
    case '%':
      consputc('%');
801004f6:	83 ec 0c             	sub    $0xc,%esp
801004f9:	6a 25                	push   $0x25
801004fb:	e8 57 02 00 00       	call   80100757 <consputc>
80100500:	83 c4 10             	add    $0x10,%esp
      break;
80100503:	eb 1c                	jmp    80100521 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100505:	83 ec 0c             	sub    $0xc,%esp
80100508:	6a 25                	push   $0x25
8010050a:	e8 48 02 00 00       	call   80100757 <consputc>
8010050f:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100512:	83 ec 0c             	sub    $0xc,%esp
80100515:	ff 75 e4             	pushl  -0x1c(%ebp)
80100518:	e8 3a 02 00 00       	call   80100757 <consputc>
8010051d:	83 c4 10             	add    $0x10,%esp
      break;
80100520:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100521:	ff 45 f4             	incl   -0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010052d:	8a 00                	mov    (%eax),%al
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c9 fe ff ff    	jne    8010040d <cprintf+0x4d>
80100544:	eb 01                	jmp    80100547 <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100546:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100547:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010054b:	74 10                	je     8010055d <cprintf+0x19d>
    release(&cons.lock);
8010054d:	83 ec 0c             	sub    $0xc,%esp
80100550:	68 c0 b5 10 80       	push   $0x8010b5c0
80100555:	e8 93 46 00 00       	call   80104bed <release>
8010055a:	83 c4 10             	add    $0x10,%esp
}
8010055d:	c9                   	leave  
8010055e:	c3                   	ret    

8010055f <panic>:

void
panic(char *s)
{
8010055f:	55                   	push   %ebp
80100560:	89 e5                	mov    %esp,%ebp
80100562:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100565:	e8 ae fd ff ff       	call   80100318 <cli>
  cons.locking = 0;
8010056a:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100571:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100574:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010057a:	8a 00                	mov    (%eax),%al
8010057c:	0f b6 c0             	movzbl %al,%eax
8010057f:	83 ec 08             	sub    $0x8,%esp
80100582:	50                   	push   %eax
80100583:	68 12 80 10 80       	push   $0x80108012
80100588:	e8 33 fe ff ff       	call   801003c0 <cprintf>
8010058d:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100590:	8b 45 08             	mov    0x8(%ebp),%eax
80100593:	83 ec 0c             	sub    $0xc,%esp
80100596:	50                   	push   %eax
80100597:	e8 24 fe ff ff       	call   801003c0 <cprintf>
8010059c:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059f:	83 ec 0c             	sub    $0xc,%esp
801005a2:	68 21 80 10 80       	push   $0x80108021
801005a7:	e8 14 fe ff ff       	call   801003c0 <cprintf>
801005ac:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005af:	83 ec 08             	sub    $0x8,%esp
801005b2:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b5:	50                   	push   %eax
801005b6:	8d 45 08             	lea    0x8(%ebp),%eax
801005b9:	50                   	push   %eax
801005ba:	e8 7f 46 00 00       	call   80104c3e <getcallerpcs>
801005bf:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c9:	eb 1b                	jmp    801005e6 <panic+0x87>
    cprintf(" %p", pcs[i]);
801005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005ce:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d2:	83 ec 08             	sub    $0x8,%esp
801005d5:	50                   	push   %eax
801005d6:	68 23 80 10 80       	push   $0x80108023
801005db:	e8 e0 fd ff ff       	call   801003c0 <cprintf>
801005e0:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e3:	ff 45 f4             	incl   -0xc(%ebp)
801005e6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005ea:	7e df                	jle    801005cb <panic+0x6c>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005ec:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005f3:	00 00 00 
  for(;;)
    ;
801005f6:	eb fe                	jmp    801005f6 <panic+0x97>

801005f8 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f8:	55                   	push   %ebp
801005f9:	89 e5                	mov    %esp,%ebp
801005fb:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fe:	6a 0e                	push   $0xe
80100600:	68 d4 03 00 00       	push   $0x3d4
80100605:	e8 f2 fc ff ff       	call   801002fc <outb>
8010060a:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060d:	68 d5 03 00 00       	push   $0x3d5
80100612:	e8 bd fc ff ff       	call   801002d4 <inb>
80100617:	83 c4 04             	add    $0x4,%esp
8010061a:	0f b6 c0             	movzbl %al,%eax
8010061d:	c1 e0 08             	shl    $0x8,%eax
80100620:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100623:	6a 0f                	push   $0xf
80100625:	68 d4 03 00 00       	push   $0x3d4
8010062a:	e8 cd fc ff ff       	call   801002fc <outb>
8010062f:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100632:	68 d5 03 00 00       	push   $0x3d5
80100637:	e8 98 fc ff ff       	call   801002d4 <inb>
8010063c:	83 c4 04             	add    $0x4,%esp
8010063f:	0f b6 c0             	movzbl %al,%eax
80100642:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100645:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100649:	75 1d                	jne    80100668 <cgaputc+0x70>
    pos += 80 - pos%80;
8010064b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010064e:	b9 50 00 00 00       	mov    $0x50,%ecx
80100653:	99                   	cltd   
80100654:	f7 f9                	idiv   %ecx
80100656:	89 d0                	mov    %edx,%eax
80100658:	ba 50 00 00 00       	mov    $0x50,%edx
8010065d:	89 d1                	mov    %edx,%ecx
8010065f:	29 c1                	sub    %eax,%ecx
80100661:	89 c8                	mov    %ecx,%eax
80100663:	01 45 f4             	add    %eax,-0xc(%ebp)
80100666:	eb 32                	jmp    8010069a <cgaputc+0xa2>
  else if(c == BACKSPACE){
80100668:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010066f:	75 0b                	jne    8010067c <cgaputc+0x84>
    if(pos > 0) --pos;
80100671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100675:	7e 23                	jle    8010069a <cgaputc+0xa2>
80100677:	ff 4d f4             	decl   -0xc(%ebp)
8010067a:	eb 1e                	jmp    8010069a <cgaputc+0xa2>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010067c:	a1 00 90 10 80       	mov    0x80109000,%eax
80100681:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100684:	d1 e2                	shl    %edx
80100686:	8d 14 10             	lea    (%eax,%edx,1),%edx
80100689:	8b 45 08             	mov    0x8(%ebp),%eax
8010068c:	25 ff 00 00 00       	and    $0xff,%eax
80100691:	80 cc 07             	or     $0x7,%ah
80100694:	66 89 02             	mov    %ax,(%edx)
80100697:	ff 45 f4             	incl   -0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010069a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006a1:	7e 4c                	jle    801006ef <cgaputc+0xf7>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006a3:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ae:	a1 00 90 10 80       	mov    0x80109000,%eax
801006b3:	83 ec 04             	sub    $0x4,%esp
801006b6:	68 60 0e 00 00       	push   $0xe60
801006bb:	52                   	push   %edx
801006bc:	50                   	push   %eax
801006bd:	e8 d4 47 00 00       	call   80104e96 <memmove>
801006c2:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006c5:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006c9:	b8 80 07 00 00       	mov    $0x780,%eax
801006ce:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006d1:	d1 e0                	shl    %eax
801006d3:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006dc:	d1 e1                	shl    %ecx
801006de:	01 ca                	add    %ecx,%edx
801006e0:	83 ec 04             	sub    $0x4,%esp
801006e3:	50                   	push   %eax
801006e4:	6a 00                	push   $0x0
801006e6:	52                   	push   %edx
801006e7:	e8 ee 46 00 00       	call   80104dda <memset>
801006ec:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
801006ef:	83 ec 08             	sub    $0x8,%esp
801006f2:	6a 0e                	push   $0xe
801006f4:	68 d4 03 00 00       	push   $0x3d4
801006f9:	e8 fe fb ff ff       	call   801002fc <outb>
801006fe:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100704:	c1 f8 08             	sar    $0x8,%eax
80100707:	0f b6 c0             	movzbl %al,%eax
8010070a:	83 ec 08             	sub    $0x8,%esp
8010070d:	50                   	push   %eax
8010070e:	68 d5 03 00 00       	push   $0x3d5
80100713:	e8 e4 fb ff ff       	call   801002fc <outb>
80100718:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010071b:	83 ec 08             	sub    $0x8,%esp
8010071e:	6a 0f                	push   $0xf
80100720:	68 d4 03 00 00       	push   $0x3d4
80100725:	e8 d2 fb ff ff       	call   801002fc <outb>
8010072a:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100730:	0f b6 c0             	movzbl %al,%eax
80100733:	83 ec 08             	sub    $0x8,%esp
80100736:	50                   	push   %eax
80100737:	68 d5 03 00 00       	push   $0x3d5
8010073c:	e8 bb fb ff ff       	call   801002fc <outb>
80100741:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100744:	a1 00 90 10 80       	mov    0x80109000,%eax
80100749:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010074c:	d1 e2                	shl    %edx
8010074e:	01 d0                	add    %edx,%eax
80100750:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100755:	c9                   	leave  
80100756:	c3                   	ret    

80100757 <consputc>:

void
consputc(int c)
{
80100757:	55                   	push   %ebp
80100758:	89 e5                	mov    %esp,%ebp
8010075a:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010075d:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80100762:	85 c0                	test   %eax,%eax
80100764:	74 07                	je     8010076d <consputc+0x16>
    cli();
80100766:	e8 ad fb ff ff       	call   80100318 <cli>
    for(;;)
      ;
8010076b:	eb fe                	jmp    8010076b <consputc+0x14>
  }

  if(c == BACKSPACE){
8010076d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100774:	75 29                	jne    8010079f <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100776:	83 ec 0c             	sub    $0xc,%esp
80100779:	6a 08                	push   $0x8
8010077b:	e8 3d 5f 00 00       	call   801066bd <uartputc>
80100780:	83 c4 10             	add    $0x10,%esp
80100783:	83 ec 0c             	sub    $0xc,%esp
80100786:	6a 20                	push   $0x20
80100788:	e8 30 5f 00 00       	call   801066bd <uartputc>
8010078d:	83 c4 10             	add    $0x10,%esp
80100790:	83 ec 0c             	sub    $0xc,%esp
80100793:	6a 08                	push   $0x8
80100795:	e8 23 5f 00 00       	call   801066bd <uartputc>
8010079a:	83 c4 10             	add    $0x10,%esp
8010079d:	eb 0e                	jmp    801007ad <consputc+0x56>
  } else
    uartputc(c);
8010079f:	83 ec 0c             	sub    $0xc,%esp
801007a2:	ff 75 08             	pushl  0x8(%ebp)
801007a5:	e8 13 5f 00 00       	call   801066bd <uartputc>
801007aa:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007ad:	83 ec 0c             	sub    $0xc,%esp
801007b0:	ff 75 08             	pushl  0x8(%ebp)
801007b3:	e8 40 fe ff ff       	call   801005f8 <cgaputc>
801007b8:	83 c4 10             	add    $0x10,%esp
}
801007bb:	c9                   	leave  
801007bc:	c3                   	ret    

801007bd <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007bd:	55                   	push   %ebp
801007be:	89 e5                	mov    %esp,%ebp
801007c0:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007c3:	83 ec 0c             	sub    $0xc,%esp
801007c6:	68 a0 dd 10 80       	push   $0x8010dda0
801007cb:	e8 b7 43 00 00       	call   80104b87 <acquire>
801007d0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007d3:	e9 4d 01 00 00       	jmp    80100925 <consoleintr+0x168>
    switch(c){
801007d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007db:	83 f8 10             	cmp    $0x10,%eax
801007de:	74 1e                	je     801007fe <consoleintr+0x41>
801007e0:	83 f8 10             	cmp    $0x10,%eax
801007e3:	7f 0a                	jg     801007ef <consoleintr+0x32>
801007e5:	83 f8 08             	cmp    $0x8,%eax
801007e8:	74 67                	je     80100851 <consoleintr+0x94>
801007ea:	e9 95 00 00 00       	jmp    80100884 <consoleintr+0xc7>
801007ef:	83 f8 15             	cmp    $0x15,%eax
801007f2:	74 31                	je     80100825 <consoleintr+0x68>
801007f4:	83 f8 7f             	cmp    $0x7f,%eax
801007f7:	74 58                	je     80100851 <consoleintr+0x94>
801007f9:	e9 86 00 00 00       	jmp    80100884 <consoleintr+0xc7>
    case C('P'):  // Process listing.
      procdump();
801007fe:	e8 26 42 00 00       	call   80104a29 <procdump>
      break;
80100803:	e9 1d 01 00 00       	jmp    80100925 <consoleintr+0x168>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100808:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010080d:	48                   	dec    %eax
8010080e:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100813:	83 ec 0c             	sub    $0xc,%esp
80100816:	68 00 01 00 00       	push   $0x100
8010081b:	e8 37 ff ff ff       	call   80100757 <consputc>
80100820:	83 c4 10             	add    $0x10,%esp
80100823:	eb 01                	jmp    80100826 <consoleintr+0x69>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100825:	90                   	nop
80100826:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010082c:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100831:	39 c2                	cmp    %eax,%edx
80100833:	0f 84 df 00 00 00    	je     80100918 <consoleintr+0x15b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100839:	a1 5c de 10 80       	mov    0x8010de5c,%eax
8010083e:	48                   	dec    %eax
8010083f:	83 e0 7f             	and    $0x7f,%eax
80100842:	8a 80 d4 dd 10 80    	mov    -0x7fef222c(%eax),%al
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100848:	3c 0a                	cmp    $0xa,%al
8010084a:	75 bc                	jne    80100808 <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010084c:	e9 d4 00 00 00       	jmp    80100925 <consoleintr+0x168>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100851:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100857:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010085c:	39 c2                	cmp    %eax,%edx
8010085e:	0f 84 b7 00 00 00    	je     8010091b <consoleintr+0x15e>
        input.e--;
80100864:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100869:	48                   	dec    %eax
8010086a:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010086f:	83 ec 0c             	sub    $0xc,%esp
80100872:	68 00 01 00 00       	push   $0x100
80100877:	e8 db fe ff ff       	call   80100757 <consputc>
8010087c:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010087f:	e9 a1 00 00 00       	jmp    80100925 <consoleintr+0x168>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100888:	0f 84 90 00 00 00    	je     8010091e <consoleintr+0x161>
8010088e:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100894:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100899:	89 d1                	mov    %edx,%ecx
8010089b:	29 c1                	sub    %eax,%ecx
8010089d:	89 c8                	mov    %ecx,%eax
8010089f:	83 f8 7f             	cmp    $0x7f,%eax
801008a2:	77 7d                	ja     80100921 <consoleintr+0x164>
        c = (c == '\r') ? '\n' : c;
801008a4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008a8:	74 05                	je     801008af <consoleintr+0xf2>
801008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008ad:	eb 05                	jmp    801008b4 <consoleintr+0xf7>
801008af:	b8 0a 00 00 00       	mov    $0xa,%eax
801008b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008b7:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008bc:	89 c1                	mov    %eax,%ecx
801008be:	83 e1 7f             	and    $0x7f,%ecx
801008c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008c4:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008ca:	40                   	inc    %eax
801008cb:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008d0:	83 ec 0c             	sub    $0xc,%esp
801008d3:	ff 75 f4             	pushl  -0xc(%ebp)
801008d6:	e8 7c fe ff ff       	call   80100757 <consputc>
801008db:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008de:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008e2:	74 18                	je     801008fc <consoleintr+0x13f>
801008e4:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008e8:	74 12                	je     801008fc <consoleintr+0x13f>
801008ea:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008ef:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008f5:	83 ea 80             	sub    $0xffffff80,%edx
801008f8:	39 d0                	cmp    %edx,%eax
801008fa:	75 28                	jne    80100924 <consoleintr+0x167>
          input.w = input.e;
801008fc:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100901:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
80100906:	83 ec 0c             	sub    $0xc,%esp
80100909:	68 54 de 10 80       	push   $0x8010de54
8010090e:	e8 5b 40 00 00       	call   8010496e <wakeup>
80100913:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100916:	eb 0d                	jmp    80100925 <consoleintr+0x168>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100918:	90                   	nop
80100919:	eb 0a                	jmp    80100925 <consoleintr+0x168>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
8010091b:	90                   	nop
8010091c:	eb 07                	jmp    80100925 <consoleintr+0x168>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
8010091e:	90                   	nop
8010091f:	eb 04                	jmp    80100925 <consoleintr+0x168>
80100921:	90                   	nop
80100922:	eb 01                	jmp    80100925 <consoleintr+0x168>
80100924:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100925:	8b 45 08             	mov    0x8(%ebp),%eax
80100928:	ff d0                	call   *%eax
8010092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010092d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100931:	0f 89 a1 fe ff ff    	jns    801007d8 <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	68 a0 dd 10 80       	push   $0x8010dda0
8010093f:	e8 a9 42 00 00       	call   80104bed <release>
80100944:	83 c4 10             	add    $0x10,%esp
}
80100947:	c9                   	leave  
80100948:	c3                   	ret    

80100949 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100949:	55                   	push   %ebp
8010094a:	89 e5                	mov    %esp,%ebp
8010094c:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010094f:	83 ec 0c             	sub    $0xc,%esp
80100952:	ff 75 08             	pushl  0x8(%ebp)
80100955:	e8 a7 10 00 00       	call   80101a01 <iunlock>
8010095a:	83 c4 10             	add    $0x10,%esp
  target = n;
8010095d:	8b 45 10             	mov    0x10(%ebp),%eax
80100960:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100963:	83 ec 0c             	sub    $0xc,%esp
80100966:	68 a0 dd 10 80       	push   $0x8010dda0
8010096b:	e8 17 42 00 00       	call   80104b87 <acquire>
80100970:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100973:	e9 a9 00 00 00       	jmp    80100a21 <consoleread+0xd8>
    while(input.r == input.w){
      if(proc->killed){
80100978:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010097e:	8b 40 24             	mov    0x24(%eax),%eax
80100981:	85 c0                	test   %eax,%eax
80100983:	74 28                	je     801009ad <consoleread+0x64>
        release(&input.lock);
80100985:	83 ec 0c             	sub    $0xc,%esp
80100988:	68 a0 dd 10 80       	push   $0x8010dda0
8010098d:	e8 5b 42 00 00       	call   80104bed <release>
80100992:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 0a 0f 00 00       	call   801018aa <ilock>
801009a0:	83 c4 10             	add    $0x10,%esp
        return -1;
801009a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009a8:	e9 aa 00 00 00       	jmp    80100a57 <consoleread+0x10e>
      }
      sleep(&input.r, &input.lock);
801009ad:	83 ec 08             	sub    $0x8,%esp
801009b0:	68 a0 dd 10 80       	push   $0x8010dda0
801009b5:	68 54 de 10 80       	push   $0x8010de54
801009ba:	e8 c5 3e 00 00       	call   80104884 <sleep>
801009bf:	83 c4 10             	add    $0x10,%esp
801009c2:	eb 01                	jmp    801009c5 <consoleread+0x7c>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009c4:	90                   	nop
801009c5:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801009cb:	a1 58 de 10 80       	mov    0x8010de58,%eax
801009d0:	39 c2                	cmp    %eax,%edx
801009d2:	74 a4                	je     80100978 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009d4:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009d9:	89 c2                	mov    %eax,%edx
801009db:	83 e2 7f             	and    $0x7f,%edx
801009de:	8a 92 d4 dd 10 80    	mov    -0x7fef222c(%edx),%dl
801009e4:	0f be d2             	movsbl %dl,%edx
801009e7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009ea:	40                   	inc    %eax
801009eb:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009f0:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009f4:	75 15                	jne    80100a0b <consoleread+0xc2>
      if(n < target){
801009f6:	8b 45 10             	mov    0x10(%ebp),%eax
801009f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009fc:	73 2b                	jae    80100a29 <consoleread+0xe0>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009fe:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100a03:	48                   	dec    %eax
80100a04:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
80100a09:	eb 22                	jmp    80100a2d <consoleread+0xe4>
    }
    *dst++ = c;
80100a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100a0e:	88 c2                	mov    %al,%dl
80100a10:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a13:	88 10                	mov    %dl,(%eax)
80100a15:	ff 45 0c             	incl   0xc(%ebp)
    --n;
80100a18:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
80100a1b:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a1f:	74 0b                	je     80100a2c <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a25:	7f 9d                	jg     801009c4 <consoleread+0x7b>
80100a27:	eb 04                	jmp    80100a2d <consoleread+0xe4>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a29:	90                   	nop
80100a2a:	eb 01                	jmp    80100a2d <consoleread+0xe4>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a2c:	90                   	nop
  }
  release(&input.lock);
80100a2d:	83 ec 0c             	sub    $0xc,%esp
80100a30:	68 a0 dd 10 80       	push   $0x8010dda0
80100a35:	e8 b3 41 00 00       	call   80104bed <release>
80100a3a:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a3d:	83 ec 0c             	sub    $0xc,%esp
80100a40:	ff 75 08             	pushl  0x8(%ebp)
80100a43:	e8 62 0e 00 00       	call   801018aa <ilock>
80100a48:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a4b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a51:	89 d1                	mov    %edx,%ecx
80100a53:	29 c1                	sub    %eax,%ecx
80100a55:	89 c8                	mov    %ecx,%eax
}
80100a57:	c9                   	leave  
80100a58:	c3                   	ret    

80100a59 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a59:	55                   	push   %ebp
80100a5a:	89 e5                	mov    %esp,%ebp
80100a5c:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a5f:	83 ec 0c             	sub    $0xc,%esp
80100a62:	ff 75 08             	pushl  0x8(%ebp)
80100a65:	e8 97 0f 00 00       	call   80101a01 <iunlock>
80100a6a:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a6d:	83 ec 0c             	sub    $0xc,%esp
80100a70:	68 c0 b5 10 80       	push   $0x8010b5c0
80100a75:	e8 0d 41 00 00       	call   80104b87 <acquire>
80100a7a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a84:	eb 1f                	jmp    80100aa5 <consolewrite+0x4c>
    consputc(buf[i] & 0xff);
80100a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a89:	03 45 0c             	add    0xc(%ebp),%eax
80100a8c:	8a 00                	mov    (%eax),%al
80100a8e:	0f be c0             	movsbl %al,%eax
80100a91:	25 ff 00 00 00       	and    $0xff,%eax
80100a96:	83 ec 0c             	sub    $0xc,%esp
80100a99:	50                   	push   %eax
80100a9a:	e8 b8 fc ff ff       	call   80100757 <consputc>
80100a9f:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aa2:	ff 45 f4             	incl   -0xc(%ebp)
80100aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aa8:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aab:	7c d9                	jl     80100a86 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	68 c0 b5 10 80       	push   $0x8010b5c0
80100ab5:	e8 33 41 00 00       	call   80104bed <release>
80100aba:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100abd:	83 ec 0c             	sub    $0xc,%esp
80100ac0:	ff 75 08             	pushl  0x8(%ebp)
80100ac3:	e8 e2 0d 00 00       	call   801018aa <ilock>
80100ac8:	83 c4 10             	add    $0x10,%esp

  return n;
80100acb:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ace:	c9                   	leave  
80100acf:	c3                   	ret    

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ad6:	83 ec 08             	sub    $0x8,%esp
80100ad9:	68 27 80 10 80       	push   $0x80108027
80100ade:	68 c0 b5 10 80       	push   $0x8010b5c0
80100ae3:	e8 7e 40 00 00       	call   80104b66 <initlock>
80100ae8:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100aeb:	83 ec 08             	sub    $0x8,%esp
80100aee:	68 2f 80 10 80       	push   $0x8010802f
80100af3:	68 a0 dd 10 80       	push   $0x8010dda0
80100af8:	e8 69 40 00 00       	call   80104b66 <initlock>
80100afd:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b00:	c7 05 0c e8 10 80 59 	movl   $0x80100a59,0x8010e80c
80100b07:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b0a:	c7 05 08 e8 10 80 49 	movl   $0x80100949,0x8010e808
80100b11:	09 10 80 
  cons.locking = 1;
80100b14:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100b1b:	00 00 00 

  picenable(IRQ_KBD);
80100b1e:	83 ec 0c             	sub    $0xc,%esp
80100b21:	6a 01                	push   $0x1
80100b23:	e8 cd 2f 00 00       	call   80103af5 <picenable>
80100b28:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b2b:	83 ec 08             	sub    $0x8,%esp
80100b2e:	6a 00                	push   $0x0
80100b30:	6a 01                	push   $0x1
80100b32:	e8 85 1e 00 00       	call   801029bc <ioapicenable>
80100b37:	83 c4 10             	add    $0x10,%esp
}
80100b3a:	c9                   	leave  
80100b3b:	c3                   	ret    

80100b3c <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b3c:	55                   	push   %ebp
80100b3d:	89 e5                	mov    %esp,%ebp
80100b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b45:	83 ec 0c             	sub    $0xc,%esp
80100b48:	ff 75 08             	pushl  0x8(%ebp)
80100b4b:	e8 f6 18 00 00       	call   80102446 <namei>
80100b50:	83 c4 10             	add    $0x10,%esp
80100b53:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b56:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b5a:	75 0a                	jne    80100b66 <exec+0x2a>
    return -1;
80100b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b61:	e9 99 03 00 00       	jmp    80100eff <exec+0x3c3>
  ilock(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	ff 75 d8             	pushl  -0x28(%ebp)
80100b6c:	e8 39 0d 00 00       	call   801018aa <ilock>
80100b71:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b74:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b7b:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b81:	6a 34                	push   $0x34
80100b83:	6a 00                	push   $0x0
80100b85:	50                   	push   %eax
80100b86:	ff 75 d8             	pushl  -0x28(%ebp)
80100b89:	e8 64 12 00 00       	call   80101df2 <readi>
80100b8e:	83 c4 10             	add    $0x10,%esp
80100b91:	83 f8 33             	cmp    $0x33,%eax
80100b94:	0f 86 19 03 00 00    	jbe    80100eb3 <exec+0x377>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b9a:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba0:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100ba5:	0f 85 0b 03 00 00    	jne    80100eb6 <exec+0x37a>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bab:	e8 25 6c 00 00       	call   801077d5 <setupkvm>
80100bb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bb3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bb7:	0f 84 fc 02 00 00    	je     80100eb9 <exec+0x37d>
    goto bad;

  // Load program into memory.
  sz = 0;
80100bbd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bcb:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bd4:	e9 ab 00 00 00       	jmp    80100c84 <exec+0x148>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
80100bdc:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100be2:	6a 20                	push   $0x20
80100be4:	52                   	push   %edx
80100be5:	50                   	push   %eax
80100be6:	ff 75 d8             	pushl  -0x28(%ebp)
80100be9:	e8 04 12 00 00       	call   80101df2 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 85 c2 02 00 00    	jne    80100ebc <exec+0x380>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bfa:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c00:	83 f8 01             	cmp    $0x1,%eax
80100c03:	75 72                	jne    80100c77 <exec+0x13b>
      continue;
    if(ph.memsz < ph.filesz)
80100c05:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c0b:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c11:	39 c2                	cmp    %eax,%edx
80100c13:	0f 82 a6 02 00 00    	jb     80100ebf <exec+0x383>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c19:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c1f:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c25:	8d 04 02             	lea    (%edx,%eax,1),%eax
80100c28:	83 ec 04             	sub    $0x4,%esp
80100c2b:	50                   	push   %eax
80100c2c:	ff 75 e0             	pushl  -0x20(%ebp)
80100c2f:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c32:	e8 41 6f 00 00       	call   80107b78 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c3d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c41:	0f 84 7b 02 00 00    	je     80100ec2 <exec+0x386>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c47:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c4d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c53:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c59:	83 ec 0c             	sub    $0xc,%esp
80100c5c:	51                   	push   %ecx
80100c5d:	52                   	push   %edx
80100c5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c61:	50                   	push   %eax
80100c62:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c65:	e8 2a 6e 00 00       	call   80107a94 <loaduvm>
80100c6a:	83 c4 20             	add    $0x20,%esp
80100c6d:	85 c0                	test   %eax,%eax
80100c6f:	0f 88 50 02 00 00    	js     80100ec5 <exec+0x389>
80100c75:	eb 01                	jmp    80100c78 <exec+0x13c>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c77:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c78:	ff 45 ec             	incl   -0x14(%ebp)
80100c7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c7e:	83 c0 20             	add    $0x20,%eax
80100c81:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c84:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
80100c8a:	0f b7 c0             	movzwl %ax,%eax
80100c8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c90:	0f 8f 43 ff ff ff    	jg     80100bd9 <exec+0x9d>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c96:	83 ec 0c             	sub    $0xc,%esp
80100c99:	ff 75 d8             	pushl  -0x28(%ebp)
80100c9c:	e8 c0 0e 00 00       	call   80101b61 <iunlockput>
80100ca1:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100ca4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cae:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cbe:	05 00 20 00 00       	add    $0x2000,%eax
80100cc3:	83 ec 04             	sub    $0x4,%esp
80100cc6:	50                   	push   %eax
80100cc7:	ff 75 e0             	pushl  -0x20(%ebp)
80100cca:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ccd:	e8 a6 6e 00 00       	call   80107b78 <allocuvm>
80100cd2:	83 c4 10             	add    $0x10,%esp
80100cd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cdc:	0f 84 e6 01 00 00    	je     80100ec8 <exec+0x38c>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce5:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cea:	83 ec 08             	sub    $0x8,%esp
80100ced:	50                   	push   %eax
80100cee:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf1:	e8 99 70 00 00       	call   80107d8f <clearpteu>
80100cf6:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfc:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d06:	eb 7c                	jmp    80100d84 <exec+0x248>
    if(argc >= MAXARG)
80100d08:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d0c:	0f 87 b9 01 00 00    	ja     80100ecb <exec+0x38f>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d15:	c1 e0 02             	shl    $0x2,%eax
80100d18:	03 45 0c             	add    0xc(%ebp),%eax
80100d1b:	8b 00                	mov    (%eax),%eax
80100d1d:	83 ec 0c             	sub    $0xc,%esp
80100d20:	50                   	push   %eax
80100d21:	e8 f8 42 00 00       	call   8010501e <strlen>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	f7 d0                	not    %eax
80100d2b:	03 45 dc             	add    -0x24(%ebp),%eax
80100d2e:	83 e0 fc             	and    $0xfffffffc,%eax
80100d31:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d37:	c1 e0 02             	shl    $0x2,%eax
80100d3a:	03 45 0c             	add    0xc(%ebp),%eax
80100d3d:	8b 00                	mov    (%eax),%eax
80100d3f:	83 ec 0c             	sub    $0xc,%esp
80100d42:	50                   	push   %eax
80100d43:	e8 d6 42 00 00       	call   8010501e <strlen>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	40                   	inc    %eax
80100d4c:	89 c2                	mov    %eax,%edx
80100d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d51:	c1 e0 02             	shl    $0x2,%eax
80100d54:	03 45 0c             	add    0xc(%ebp),%eax
80100d57:	8b 00                	mov    (%eax),%eax
80100d59:	52                   	push   %edx
80100d5a:	50                   	push   %eax
80100d5b:	ff 75 dc             	pushl  -0x24(%ebp)
80100d5e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d61:	e8 ca 71 00 00       	call   80107f30 <copyout>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	85 c0                	test   %eax,%eax
80100d6b:	0f 88 5d 01 00 00    	js     80100ece <exec+0x392>
      goto bad;
    ustack[3+argc] = sp;
80100d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d74:	8d 50 03             	lea    0x3(%eax),%edx
80100d77:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d7a:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d81:	ff 45 e4             	incl   -0x1c(%ebp)
80100d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d87:	c1 e0 02             	shl    $0x2,%eax
80100d8a:	03 45 0c             	add    0xc(%ebp),%eax
80100d8d:	8b 00                	mov    (%eax),%eax
80100d8f:	85 c0                	test   %eax,%eax
80100d91:	0f 85 71 ff ff ff    	jne    80100d08 <exec+0x1cc>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9a:	83 c0 03             	add    $0x3,%eax
80100d9d:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100da4:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100da8:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100daf:	ff ff ff 
  ustack[1] = argc;
80100db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db5:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbe:	40                   	inc    %eax
80100dbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc9:	29 d0                	sub    %edx,%eax
80100dcb:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd4:	83 c0 04             	add    $0x4,%eax
80100dd7:	c1 e0 02             	shl    $0x2,%eax
80100dda:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ddd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de0:	83 c0 04             	add    $0x4,%eax
80100de3:	c1 e0 02             	shl    $0x2,%eax
80100de6:	50                   	push   %eax
80100de7:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ded:	50                   	push   %eax
80100dee:	ff 75 dc             	pushl  -0x24(%ebp)
80100df1:	ff 75 d4             	pushl  -0x2c(%ebp)
80100df4:	e8 37 71 00 00       	call   80107f30 <copyout>
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	85 c0                	test   %eax,%eax
80100dfe:	0f 88 cd 00 00 00    	js     80100ed1 <exec+0x395>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e04:	8b 45 08             	mov    0x8(%ebp),%eax
80100e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e10:	eb 13                	jmp    80100e25 <exec+0x2e9>
    if(*s == '/')
80100e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e15:	8a 00                	mov    (%eax),%al
80100e17:	3c 2f                	cmp    $0x2f,%al
80100e19:	75 07                	jne    80100e22 <exec+0x2e6>
      last = s+1;
80100e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e1e:	40                   	inc    %eax
80100e1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e22:	ff 45 f4             	incl   -0xc(%ebp)
80100e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e28:	8a 00                	mov    (%eax),%al
80100e2a:	84 c0                	test   %al,%al
80100e2c:	75 e4                	jne    80100e12 <exec+0x2d6>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e34:	83 c0 6c             	add    $0x6c,%eax
80100e37:	83 ec 04             	sub    $0x4,%esp
80100e3a:	6a 10                	push   $0x10
80100e3c:	ff 75 f0             	pushl  -0x10(%ebp)
80100e3f:	50                   	push   %eax
80100e40:	e8 90 41 00 00       	call   80104fd5 <safestrcpy>
80100e45:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e4e:	8b 40 04             	mov    0x4(%eax),%eax
80100e51:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e5a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e5d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e66:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e69:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e71:	8b 40 18             	mov    0x18(%eax),%eax
80100e74:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e7a:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e83:	8b 40 18             	mov    0x18(%eax),%eax
80100e86:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e89:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e92:	83 ec 0c             	sub    $0xc,%esp
80100e95:	50                   	push   %eax
80100e96:	e8 20 6a 00 00       	call   801078bb <switchuvm>
80100e9b:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100e9e:	83 ec 0c             	sub    $0xc,%esp
80100ea1:	ff 75 d0             	pushl  -0x30(%ebp)
80100ea4:	e8 53 6e 00 00       	call   80107cfc <freevm>
80100ea9:	83 c4 10             	add    $0x10,%esp
  return 0;
80100eac:	b8 00 00 00 00       	mov    $0x0,%eax
80100eb1:	eb 4c                	jmp    80100eff <exec+0x3c3>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100eb3:	90                   	nop
80100eb4:	eb 1c                	jmp    80100ed2 <exec+0x396>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eb6:	90                   	nop
80100eb7:	eb 19                	jmp    80100ed2 <exec+0x396>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100eb9:	90                   	nop
80100eba:	eb 16                	jmp    80100ed2 <exec+0x396>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ebc:	90                   	nop
80100ebd:	eb 13                	jmp    80100ed2 <exec+0x396>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ebf:	90                   	nop
80100ec0:	eb 10                	jmp    80100ed2 <exec+0x396>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ec2:	90                   	nop
80100ec3:	eb 0d                	jmp    80100ed2 <exec+0x396>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ec5:	90                   	nop
80100ec6:	eb 0a                	jmp    80100ed2 <exec+0x396>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ec8:	90                   	nop
80100ec9:	eb 07                	jmp    80100ed2 <exec+0x396>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ecb:	90                   	nop
80100ecc:	eb 04                	jmp    80100ed2 <exec+0x396>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ece:	90                   	nop
80100ecf:	eb 01                	jmp    80100ed2 <exec+0x396>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ed1:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ed2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ed6:	74 0e                	je     80100ee6 <exec+0x3aa>
    freevm(pgdir);
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ede:	e8 19 6e 00 00       	call   80107cfc <freevm>
80100ee3:	83 c4 10             	add    $0x10,%esp
  if(ip)
80100ee6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100eea:	74 0e                	je     80100efa <exec+0x3be>
    iunlockput(ip);
80100eec:	83 ec 0c             	sub    $0xc,%esp
80100eef:	ff 75 d8             	pushl  -0x28(%ebp)
80100ef2:	e8 6a 0c 00 00       	call   80101b61 <iunlockput>
80100ef7:	83 c4 10             	add    $0x10,%esp
  return -1;
80100efa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100eff:	c9                   	leave  
80100f00:	c3                   	ret    
80100f01:	00 00                	add    %al,(%eax)
	...

80100f04 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f04:	55                   	push   %ebp
80100f05:	89 e5                	mov    %esp,%ebp
80100f07:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f0a:	83 ec 08             	sub    $0x8,%esp
80100f0d:	68 35 80 10 80       	push   $0x80108035
80100f12:	68 60 de 10 80       	push   $0x8010de60
80100f17:	e8 4a 3c 00 00       	call   80104b66 <initlock>
80100f1c:	83 c4 10             	add    $0x10,%esp
}
80100f1f:	c9                   	leave  
80100f20:	c3                   	ret    

80100f21 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f21:	55                   	push   %ebp
80100f22:	89 e5                	mov    %esp,%ebp
80100f24:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f27:	83 ec 0c             	sub    $0xc,%esp
80100f2a:	68 60 de 10 80       	push   $0x8010de60
80100f2f:	e8 53 3c 00 00       	call   80104b87 <acquire>
80100f34:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f37:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f3e:	eb 2d                	jmp    80100f6d <filealloc+0x4c>
    if(f->ref == 0){
80100f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f43:	8b 40 04             	mov    0x4(%eax),%eax
80100f46:	85 c0                	test   %eax,%eax
80100f48:	75 1f                	jne    80100f69 <filealloc+0x48>
      f->ref = 1;
80100f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f4d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	68 60 de 10 80       	push   $0x8010de60
80100f5c:	e8 8c 3c 00 00       	call   80104bed <release>
80100f61:	83 c4 10             	add    $0x10,%esp
      return f;
80100f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f67:	eb 23                	jmp    80100f8c <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f69:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f6d:	b8 f4 e7 10 80       	mov    $0x8010e7f4,%eax
80100f72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100f75:	72 c9                	jb     80100f40 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f77:	83 ec 0c             	sub    $0xc,%esp
80100f7a:	68 60 de 10 80       	push   $0x8010de60
80100f7f:	e8 69 3c 00 00       	call   80104bed <release>
80100f84:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f8c:	c9                   	leave  
80100f8d:	c3                   	ret    

80100f8e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f8e:	55                   	push   %ebp
80100f8f:	89 e5                	mov    %esp,%ebp
80100f91:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100f94:	83 ec 0c             	sub    $0xc,%esp
80100f97:	68 60 de 10 80       	push   $0x8010de60
80100f9c:	e8 e6 3b 00 00       	call   80104b87 <acquire>
80100fa1:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa7:	8b 40 04             	mov    0x4(%eax),%eax
80100faa:	85 c0                	test   %eax,%eax
80100fac:	7f 0d                	jg     80100fbb <filedup+0x2d>
    panic("filedup");
80100fae:	83 ec 0c             	sub    $0xc,%esp
80100fb1:	68 3c 80 10 80       	push   $0x8010803c
80100fb6:	e8 a4 f5 ff ff       	call   8010055f <panic>
  f->ref++;
80100fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80100fbe:	8b 40 04             	mov    0x4(%eax),%eax
80100fc1:	8d 50 01             	lea    0x1(%eax),%edx
80100fc4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc7:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fca:	83 ec 0c             	sub    $0xc,%esp
80100fcd:	68 60 de 10 80       	push   $0x8010de60
80100fd2:	e8 16 3c 00 00       	call   80104bed <release>
80100fd7:	83 c4 10             	add    $0x10,%esp
  return f;
80100fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fdd:	c9                   	leave  
80100fde:	c3                   	ret    

80100fdf <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fdf:	55                   	push   %ebp
80100fe0:	89 e5                	mov    %esp,%ebp
80100fe2:	57                   	push   %edi
80100fe3:	56                   	push   %esi
80100fe4:	53                   	push   %ebx
80100fe5:	83 ec 2c             	sub    $0x2c,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	68 60 de 10 80       	push   $0x8010de60
80100ff0:	e8 92 3b 00 00       	call   80104b87 <acquire>
80100ff5:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffb:	8b 40 04             	mov    0x4(%eax),%eax
80100ffe:	85 c0                	test   %eax,%eax
80101000:	7f 0d                	jg     8010100f <fileclose+0x30>
    panic("fileclose");
80101002:	83 ec 0c             	sub    $0xc,%esp
80101005:	68 44 80 10 80       	push   $0x80108044
8010100a:	e8 50 f5 ff ff       	call   8010055f <panic>
  if(--f->ref > 0){
8010100f:	8b 45 08             	mov    0x8(%ebp),%eax
80101012:	8b 40 04             	mov    0x4(%eax),%eax
80101015:	8d 50 ff             	lea    -0x1(%eax),%edx
80101018:	8b 45 08             	mov    0x8(%ebp),%eax
8010101b:	89 50 04             	mov    %edx,0x4(%eax)
8010101e:	8b 45 08             	mov    0x8(%ebp),%eax
80101021:	8b 40 04             	mov    0x4(%eax),%eax
80101024:	85 c0                	test   %eax,%eax
80101026:	7e 12                	jle    8010103a <fileclose+0x5b>
    release(&ftable.lock);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	68 60 de 10 80       	push   $0x8010de60
80101030:	e8 b8 3b 00 00       	call   80104bed <release>
80101035:	83 c4 10             	add    $0x10,%esp
    return;
80101038:	eb 79                	jmp    801010b3 <fileclose+0xd4>
  }
  ff = *f;
8010103a:	8b 45 08             	mov    0x8(%ebp),%eax
8010103d:	8d 55 d0             	lea    -0x30(%ebp),%edx
80101040:	89 c3                	mov    %eax,%ebx
80101042:	b8 06 00 00 00       	mov    $0x6,%eax
80101047:	89 d7                	mov    %edx,%edi
80101049:	89 de                	mov    %ebx,%esi
8010104b:	89 c1                	mov    %eax,%ecx
8010104d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
8010104f:	8b 45 08             	mov    0x8(%ebp),%eax
80101052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101059:	8b 45 08             	mov    0x8(%ebp),%eax
8010105c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101062:	83 ec 0c             	sub    $0xc,%esp
80101065:	68 60 de 10 80       	push   $0x8010de60
8010106a:	e8 7e 3b 00 00       	call   80104bed <release>
8010106f:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101072:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101075:	83 f8 01             	cmp    $0x1,%eax
80101078:	75 18                	jne    80101092 <fileclose+0xb3>
    pipeclose(ff.pipe, ff.writable);
8010107a:	8a 45 d9             	mov    -0x27(%ebp),%al
8010107d:	0f be d0             	movsbl %al,%edx
80101080:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101083:	83 ec 08             	sub    $0x8,%esp
80101086:	52                   	push   %edx
80101087:	50                   	push   %eax
80101088:	e8 cf 2c 00 00       	call   80103d5c <pipeclose>
8010108d:	83 c4 10             	add    $0x10,%esp
80101090:	eb 21                	jmp    801010b3 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101092:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101095:	83 f8 02             	cmp    $0x2,%eax
80101098:	75 19                	jne    801010b3 <fileclose+0xd4>
    begin_trans();
8010109a:	e8 6c 21 00 00       	call   8010320b <begin_trans>
    iput(ff.ip);
8010109f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a2:	83 ec 0c             	sub    $0xc,%esp
801010a5:	50                   	push   %eax
801010a6:	e8 c7 09 00 00       	call   80101a72 <iput>
801010ab:	83 c4 10             	add    $0x10,%esp
    commit_trans();
801010ae:	e8 aa 21 00 00       	call   8010325d <commit_trans>
  }
}
801010b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b6:	83 c4 00             	add    $0x0,%esp
801010b9:	5b                   	pop    %ebx
801010ba:	5e                   	pop    %esi
801010bb:	5f                   	pop    %edi
801010bc:	c9                   	leave  
801010bd:	c3                   	ret    

801010be <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010be:	55                   	push   %ebp
801010bf:	89 e5                	mov    %esp,%ebp
801010c1:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801010c4:	8b 45 08             	mov    0x8(%ebp),%eax
801010c7:	8b 00                	mov    (%eax),%eax
801010c9:	83 f8 02             	cmp    $0x2,%eax
801010cc:	75 40                	jne    8010110e <filestat+0x50>
    ilock(f->ip);
801010ce:	8b 45 08             	mov    0x8(%ebp),%eax
801010d1:	8b 40 10             	mov    0x10(%eax),%eax
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	50                   	push   %eax
801010d8:	e8 cd 07 00 00       	call   801018aa <ilock>
801010dd:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	8b 40 10             	mov    0x10(%eax),%eax
801010e6:	83 ec 08             	sub    $0x8,%esp
801010e9:	ff 75 0c             	pushl  0xc(%ebp)
801010ec:	50                   	push   %eax
801010ed:	e8 bc 0c 00 00       	call   80101dae <stati>
801010f2:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801010f5:	8b 45 08             	mov    0x8(%ebp),%eax
801010f8:	8b 40 10             	mov    0x10(%eax),%eax
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	50                   	push   %eax
801010ff:	e8 fd 08 00 00       	call   80101a01 <iunlock>
80101104:	83 c4 10             	add    $0x10,%esp
    return 0;
80101107:	b8 00 00 00 00       	mov    $0x0,%eax
8010110c:	eb 05                	jmp    80101113 <filestat+0x55>
  }
  return -1;
8010110e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101113:	c9                   	leave  
80101114:	c3                   	ret    

80101115 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101115:	55                   	push   %ebp
80101116:	89 e5                	mov    %esp,%ebp
80101118:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010111b:	8b 45 08             	mov    0x8(%ebp),%eax
8010111e:	8a 40 08             	mov    0x8(%eax),%al
80101121:	84 c0                	test   %al,%al
80101123:	75 0a                	jne    8010112f <fileread+0x1a>
    return -1;
80101125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112a:	e9 9b 00 00 00       	jmp    801011ca <fileread+0xb5>
  if(f->type == FD_PIPE)
8010112f:	8b 45 08             	mov    0x8(%ebp),%eax
80101132:	8b 00                	mov    (%eax),%eax
80101134:	83 f8 01             	cmp    $0x1,%eax
80101137:	75 1a                	jne    80101153 <fileread+0x3e>
    return piperead(f->pipe, addr, n);
80101139:	8b 45 08             	mov    0x8(%ebp),%eax
8010113c:	8b 40 0c             	mov    0xc(%eax),%eax
8010113f:	83 ec 04             	sub    $0x4,%esp
80101142:	ff 75 10             	pushl  0x10(%ebp)
80101145:	ff 75 0c             	pushl  0xc(%ebp)
80101148:	50                   	push   %eax
80101149:	e8 ba 2d 00 00       	call   80103f08 <piperead>
8010114e:	83 c4 10             	add    $0x10,%esp
80101151:	eb 77                	jmp    801011ca <fileread+0xb5>
  if(f->type == FD_INODE){
80101153:	8b 45 08             	mov    0x8(%ebp),%eax
80101156:	8b 00                	mov    (%eax),%eax
80101158:	83 f8 02             	cmp    $0x2,%eax
8010115b:	75 60                	jne    801011bd <fileread+0xa8>
    ilock(f->ip);
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	8b 40 10             	mov    0x10(%eax),%eax
80101163:	83 ec 0c             	sub    $0xc,%esp
80101166:	50                   	push   %eax
80101167:	e8 3e 07 00 00       	call   801018aa <ilock>
8010116c:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101172:	8b 45 08             	mov    0x8(%ebp),%eax
80101175:	8b 50 14             	mov    0x14(%eax),%edx
80101178:	8b 45 08             	mov    0x8(%ebp),%eax
8010117b:	8b 40 10             	mov    0x10(%eax),%eax
8010117e:	51                   	push   %ecx
8010117f:	52                   	push   %edx
80101180:	ff 75 0c             	pushl  0xc(%ebp)
80101183:	50                   	push   %eax
80101184:	e8 69 0c 00 00       	call   80101df2 <readi>
80101189:	83 c4 10             	add    $0x10,%esp
8010118c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010118f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101193:	7e 11                	jle    801011a6 <fileread+0x91>
      f->off += r;
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	8b 50 14             	mov    0x14(%eax),%edx
8010119b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010119e:	01 c2                	add    %eax,%edx
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011a6:	8b 45 08             	mov    0x8(%ebp),%eax
801011a9:	8b 40 10             	mov    0x10(%eax),%eax
801011ac:	83 ec 0c             	sub    $0xc,%esp
801011af:	50                   	push   %eax
801011b0:	e8 4c 08 00 00       	call   80101a01 <iunlock>
801011b5:	83 c4 10             	add    $0x10,%esp
    return r;
801011b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011bb:	eb 0d                	jmp    801011ca <fileread+0xb5>
  }
  panic("fileread");
801011bd:	83 ec 0c             	sub    $0xc,%esp
801011c0:	68 4e 80 10 80       	push   $0x8010804e
801011c5:	e8 95 f3 ff ff       	call   8010055f <panic>
}
801011ca:	c9                   	leave  
801011cb:	c3                   	ret    

801011cc <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011cc:	55                   	push   %ebp
801011cd:	89 e5                	mov    %esp,%ebp
801011cf:	53                   	push   %ebx
801011d0:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801011d3:	8b 45 08             	mov    0x8(%ebp),%eax
801011d6:	8a 40 09             	mov    0x9(%eax),%al
801011d9:	84 c0                	test   %al,%al
801011db:	75 0a                	jne    801011e7 <filewrite+0x1b>
    return -1;
801011dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011e2:	e9 21 01 00 00       	jmp    80101308 <filewrite+0x13c>
  if(f->type == FD_PIPE)
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 00                	mov    (%eax),%eax
801011ec:	83 f8 01             	cmp    $0x1,%eax
801011ef:	75 1d                	jne    8010120e <filewrite+0x42>
    return pipewrite(f->pipe, addr, n);
801011f1:	8b 45 08             	mov    0x8(%ebp),%eax
801011f4:	8b 40 0c             	mov    0xc(%eax),%eax
801011f7:	83 ec 04             	sub    $0x4,%esp
801011fa:	ff 75 10             	pushl  0x10(%ebp)
801011fd:	ff 75 0c             	pushl  0xc(%ebp)
80101200:	50                   	push   %eax
80101201:	e8 00 2c 00 00       	call   80103e06 <pipewrite>
80101206:	83 c4 10             	add    $0x10,%esp
80101209:	e9 fa 00 00 00       	jmp    80101308 <filewrite+0x13c>
  if(f->type == FD_INODE){
8010120e:	8b 45 08             	mov    0x8(%ebp),%eax
80101211:	8b 00                	mov    (%eax),%eax
80101213:	83 f8 02             	cmp    $0x2,%eax
80101216:	0f 85 df 00 00 00    	jne    801012fb <filewrite+0x12f>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010121c:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010122a:	e9 a9 00 00 00       	jmp    801012d8 <filewrite+0x10c>
      int n1 = n - i;
8010122f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101232:	8b 55 10             	mov    0x10(%ebp),%edx
80101235:	89 d1                	mov    %edx,%ecx
80101237:	29 c1                	sub    %eax,%ecx
80101239:	89 c8                	mov    %ecx,%eax
8010123b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010123e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101241:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101244:	7e 06                	jle    8010124c <filewrite+0x80>
        n1 = max;
80101246:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101249:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010124c:	e8 ba 1f 00 00       	call   8010320b <begin_trans>
      ilock(f->ip);
80101251:	8b 45 08             	mov    0x8(%ebp),%eax
80101254:	8b 40 10             	mov    0x10(%eax),%eax
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	50                   	push   %eax
8010125b:	e8 4a 06 00 00       	call   801018aa <ilock>
80101260:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101263:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80101266:	8b 45 08             	mov    0x8(%ebp),%eax
80101269:	8b 48 14             	mov    0x14(%eax),%ecx
8010126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010126f:	89 c2                	mov    %eax,%edx
80101271:	03 55 0c             	add    0xc(%ebp),%edx
80101274:	8b 45 08             	mov    0x8(%ebp),%eax
80101277:	8b 40 10             	mov    0x10(%eax),%eax
8010127a:	53                   	push   %ebx
8010127b:	51                   	push   %ecx
8010127c:	52                   	push   %edx
8010127d:	50                   	push   %eax
8010127e:	e8 cf 0c 00 00       	call   80101f52 <writei>
80101283:	83 c4 10             	add    $0x10,%esp
80101286:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101289:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010128d:	7e 11                	jle    801012a0 <filewrite+0xd4>
        f->off += r;
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 50 14             	mov    0x14(%eax),%edx
80101295:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101298:	01 c2                	add    %eax,%edx
8010129a:	8b 45 08             	mov    0x8(%ebp),%eax
8010129d:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012a0:	8b 45 08             	mov    0x8(%ebp),%eax
801012a3:	8b 40 10             	mov    0x10(%eax),%eax
801012a6:	83 ec 0c             	sub    $0xc,%esp
801012a9:	50                   	push   %eax
801012aa:	e8 52 07 00 00       	call   80101a01 <iunlock>
801012af:	83 c4 10             	add    $0x10,%esp
      commit_trans();
801012b2:	e8 a6 1f 00 00       	call   8010325d <commit_trans>

      if(r < 0)
801012b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012bb:	78 29                	js     801012e6 <filewrite+0x11a>
        break;
      if(r != n1)
801012bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012c3:	74 0d                	je     801012d2 <filewrite+0x106>
        panic("short filewrite");
801012c5:	83 ec 0c             	sub    $0xc,%esp
801012c8:	68 57 80 10 80       	push   $0x80108057
801012cd:	e8 8d f2 ff ff       	call   8010055f <panic>
      i += r;
801012d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d5:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012db:	3b 45 10             	cmp    0x10(%ebp),%eax
801012de:	0f 8c 4b ff ff ff    	jl     8010122f <filewrite+0x63>
801012e4:	eb 01                	jmp    801012e7 <filewrite+0x11b>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012e6:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ea:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ed:	75 05                	jne    801012f4 <filewrite+0x128>
801012ef:	8b 45 10             	mov    0x10(%ebp),%eax
801012f2:	eb 05                	jmp    801012f9 <filewrite+0x12d>
801012f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f9:	eb 0d                	jmp    80101308 <filewrite+0x13c>
  }
  panic("filewrite");
801012fb:	83 ec 0c             	sub    $0xc,%esp
801012fe:	68 67 80 10 80       	push   $0x80108067
80101303:	e8 57 f2 ff ff       	call   8010055f <panic>
}
80101308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010130b:	c9                   	leave  
8010130c:	c3                   	ret    
8010130d:	00 00                	add    %al,(%eax)
	...

80101310 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	83 ec 08             	sub    $0x8,%esp
8010131c:	6a 01                	push   $0x1
8010131e:	50                   	push   %eax
8010131f:	e8 91 ee ff ff       	call   801001b5 <bread>
80101324:	83 c4 10             	add    $0x10,%esp
80101327:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	83 c0 18             	add    $0x18,%eax
80101330:	83 ec 04             	sub    $0x4,%esp
80101333:	6a 10                	push   $0x10
80101335:	50                   	push   %eax
80101336:	ff 75 0c             	pushl  0xc(%ebp)
80101339:	e8 58 3b 00 00       	call   80104e96 <memmove>
8010133e:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	ff 75 f4             	pushl  -0xc(%ebp)
80101347:	e8 e0 ee ff ff       	call   8010022c <brelse>
8010134c:	83 c4 10             	add    $0x10,%esp
}
8010134f:	c9                   	leave  
80101350:	c3                   	ret    

80101351 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101351:	55                   	push   %ebp
80101352:	89 e5                	mov    %esp,%ebp
80101354:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101357:	8b 55 0c             	mov    0xc(%ebp),%edx
8010135a:	8b 45 08             	mov    0x8(%ebp),%eax
8010135d:	83 ec 08             	sub    $0x8,%esp
80101360:	52                   	push   %edx
80101361:	50                   	push   %eax
80101362:	e8 4e ee ff ff       	call   801001b5 <bread>
80101367:	83 c4 10             	add    $0x10,%esp
8010136a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010136d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101370:	83 c0 18             	add    $0x18,%eax
80101373:	83 ec 04             	sub    $0x4,%esp
80101376:	68 00 02 00 00       	push   $0x200
8010137b:	6a 00                	push   $0x0
8010137d:	50                   	push   %eax
8010137e:	e8 57 3a 00 00       	call   80104dda <memset>
80101383:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	ff 75 f4             	pushl  -0xc(%ebp)
8010138c:	e8 30 1f 00 00       	call   801032c1 <log_write>
80101391:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101394:	83 ec 0c             	sub    $0xc,%esp
80101397:	ff 75 f4             	pushl  -0xc(%ebp)
8010139a:	e8 8d ee ff ff       	call   8010022c <brelse>
8010139f:	83 c4 10             	add    $0x10,%esp
}
801013a2:	c9                   	leave  
801013a3:	c3                   	ret    

801013a4 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013a4:	55                   	push   %ebp
801013a5:	89 e5                	mov    %esp,%ebp
801013a7:	53                   	push   %ebx
801013a8:	83 ec 24             	sub    $0x24,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013b2:	8b 45 08             	mov    0x8(%ebp),%eax
801013b5:	83 ec 08             	sub    $0x8,%esp
801013b8:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013bb:	52                   	push   %edx
801013bc:	50                   	push   %eax
801013bd:	e8 4e ff ff ff       	call   80101310 <readsb>
801013c2:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
801013c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013cc:	e9 14 01 00 00       	jmp    801014e5 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d4:	85 c0                	test   %eax,%eax
801013d6:	79 05                	jns    801013dd <balloc+0x39>
801013d8:	05 ff 0f 00 00       	add    $0xfff,%eax
801013dd:	c1 f8 0c             	sar    $0xc,%eax
801013e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013e3:	c1 ea 03             	shr    $0x3,%edx
801013e6:	01 d0                	add    %edx,%eax
801013e8:	83 c0 03             	add    $0x3,%eax
801013eb:	83 ec 08             	sub    $0x8,%esp
801013ee:	50                   	push   %eax
801013ef:	ff 75 08             	pushl  0x8(%ebp)
801013f2:	e8 be ed ff ff       	call   801001b5 <bread>
801013f7:	83 c4 10             	add    $0x10,%esp
801013fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101404:	e9 a8 00 00 00       	jmp    801014b1 <balloc+0x10d>
      m = 1 << (bi % 8);
80101409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140c:	25 07 00 00 80       	and    $0x80000007,%eax
80101411:	85 c0                	test   %eax,%eax
80101413:	79 05                	jns    8010141a <balloc+0x76>
80101415:	48                   	dec    %eax
80101416:	83 c8 f8             	or     $0xfffffff8,%eax
80101419:	40                   	inc    %eax
8010141a:	ba 01 00 00 00       	mov    $0x1,%edx
8010141f:	89 d3                	mov    %edx,%ebx
80101421:	88 c1                	mov    %al,%cl
80101423:	d3 e3                	shl    %cl,%ebx
80101425:	89 d8                	mov    %ebx,%eax
80101427:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142d:	85 c0                	test   %eax,%eax
8010142f:	79 03                	jns    80101434 <balloc+0x90>
80101431:	83 c0 07             	add    $0x7,%eax
80101434:	c1 f8 03             	sar    $0x3,%eax
80101437:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143a:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010143e:	0f b6 c0             	movzbl %al,%eax
80101441:	23 45 e8             	and    -0x18(%ebp),%eax
80101444:	85 c0                	test   %eax,%eax
80101446:	75 66                	jne    801014ae <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
80101448:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144b:	85 c0                	test   %eax,%eax
8010144d:	79 03                	jns    80101452 <balloc+0xae>
8010144f:	83 c0 07             	add    $0x7,%eax
80101452:	c1 f8 03             	sar    $0x3,%eax
80101455:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101458:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
8010145c:	88 d1                	mov    %dl,%cl
8010145e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101461:	09 ca                	or     %ecx,%edx
80101463:	88 d1                	mov    %dl,%cl
80101465:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101468:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	ff 75 ec             	pushl  -0x14(%ebp)
80101472:	e8 4a 1e 00 00       	call   801032c1 <log_write>
80101477:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010147a:	83 ec 0c             	sub    $0xc,%esp
8010147d:	ff 75 ec             	pushl  -0x14(%ebp)
80101480:	e8 a7 ed ff ff       	call   8010022c <brelse>
80101485:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101488:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148e:	01 c2                	add    %eax,%edx
80101490:	8b 45 08             	mov    0x8(%ebp),%eax
80101493:	83 ec 08             	sub    $0x8,%esp
80101496:	52                   	push   %edx
80101497:	50                   	push   %eax
80101498:	e8 b4 fe ff ff       	call   80101351 <bzero>
8010149d:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a6:	8d 04 02             	lea    (%edx,%eax,1),%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801014a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014ac:	c9                   	leave  
801014ad:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014ae:	ff 45 f0             	incl   -0x10(%ebp)
801014b1:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b8:	7f 16                	jg     801014d0 <balloc+0x12c>
801014ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c0:	8d 04 02             	lea    (%edx,%eax,1),%eax
801014c3:	89 c2                	mov    %eax,%edx
801014c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c8:	39 c2                	cmp    %eax,%edx
801014ca:	0f 82 39 ff ff ff    	jb     80101409 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014d0:	83 ec 0c             	sub    $0xc,%esp
801014d3:	ff 75 ec             	pushl  -0x14(%ebp)
801014d6:	e8 51 ed ff ff       	call   8010022c <brelse>
801014db:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014eb:	39 c2                	cmp    %eax,%edx
801014ed:	0f 82 de fe ff ff    	jb     801013d1 <balloc+0x2d>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014f3:	83 ec 0c             	sub    $0xc,%esp
801014f6:	68 71 80 10 80       	push   $0x80108071
801014fb:	e8 5f f0 ff ff       	call   8010055f <panic>

80101500 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	53                   	push   %ebx
80101504:	83 ec 24             	sub    $0x24,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101507:	83 ec 08             	sub    $0x8,%esp
8010150a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010150d:	50                   	push   %eax
8010150e:	ff 75 08             	pushl  0x8(%ebp)
80101511:	e8 fa fd ff ff       	call   80101310 <readsb>
80101516:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151c:	89 c2                	mov    %eax,%edx
8010151e:	c1 ea 0c             	shr    $0xc,%edx
80101521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101524:	c1 e8 03             	shr    $0x3,%eax
80101527:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010152a:	8d 50 03             	lea    0x3(%eax),%edx
8010152d:	8b 45 08             	mov    0x8(%ebp),%eax
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	52                   	push   %edx
80101534:	50                   	push   %eax
80101535:	e8 7b ec ff ff       	call   801001b5 <bread>
8010153a:	83 c4 10             	add    $0x10,%esp
8010153d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101540:	8b 45 0c             	mov    0xc(%ebp),%eax
80101543:	25 ff 0f 00 00       	and    $0xfff,%eax
80101548:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010154b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154e:	25 07 00 00 80       	and    $0x80000007,%eax
80101553:	85 c0                	test   %eax,%eax
80101555:	79 05                	jns    8010155c <bfree+0x5c>
80101557:	48                   	dec    %eax
80101558:	83 c8 f8             	or     $0xfffffff8,%eax
8010155b:	40                   	inc    %eax
8010155c:	ba 01 00 00 00       	mov    $0x1,%edx
80101561:	89 d3                	mov    %edx,%ebx
80101563:	88 c1                	mov    %al,%cl
80101565:	d3 e3                	shl    %cl,%ebx
80101567:	89 d8                	mov    %ebx,%eax
80101569:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010156c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156f:	85 c0                	test   %eax,%eax
80101571:	79 03                	jns    80101576 <bfree+0x76>
80101573:	83 c0 07             	add    $0x7,%eax
80101576:	c1 f8 03             	sar    $0x3,%eax
80101579:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010157c:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
80101580:	0f b6 c0             	movzbl %al,%eax
80101583:	23 45 ec             	and    -0x14(%ebp),%eax
80101586:	85 c0                	test   %eax,%eax
80101588:	75 0d                	jne    80101597 <bfree+0x97>
    panic("freeing free block");
8010158a:	83 ec 0c             	sub    $0xc,%esp
8010158d:	68 87 80 10 80       	push   $0x80108087
80101592:	e8 c8 ef ff ff       	call   8010055f <panic>
  bp->data[bi/8] &= ~m;
80101597:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010159a:	85 c0                	test   %eax,%eax
8010159c:	79 03                	jns    801015a1 <bfree+0xa1>
8010159e:	83 c0 07             	add    $0x7,%eax
801015a1:	c1 f8 03             	sar    $0x3,%eax
801015a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a7:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
801015ab:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015ae:	f7 d1                	not    %ecx
801015b0:	21 ca                	and    %ecx,%edx
801015b2:	88 d1                	mov    %dl,%cl
801015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b7:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015bb:	83 ec 0c             	sub    $0xc,%esp
801015be:	ff 75 f4             	pushl  -0xc(%ebp)
801015c1:	e8 fb 1c 00 00       	call   801032c1 <log_write>
801015c6:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015c9:	83 ec 0c             	sub    $0xc,%esp
801015cc:	ff 75 f4             	pushl  -0xc(%ebp)
801015cf:	e8 58 ec ff ff       	call   8010022c <brelse>
801015d4:	83 c4 10             	add    $0x10,%esp
}
801015d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015da:	c9                   	leave  
801015db:	c3                   	ret    

801015dc <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015dc:	55                   	push   %ebp
801015dd:	89 e5                	mov    %esp,%ebp
801015df:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
801015e2:	83 ec 08             	sub    $0x8,%esp
801015e5:	68 9a 80 10 80       	push   $0x8010809a
801015ea:	68 60 e8 10 80       	push   $0x8010e860
801015ef:	e8 72 35 00 00       	call   80104b66 <initlock>
801015f4:	83 c4 10             	add    $0x10,%esp
}
801015f7:	c9                   	leave  
801015f8:	c3                   	ret    

801015f9 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015f9:	55                   	push   %ebp
801015fa:	89 e5                	mov    %esp,%ebp
801015fc:	83 ec 38             	sub    $0x38,%esp
801015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80101602:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101606:	8b 45 08             	mov    0x8(%ebp),%eax
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010160f:	52                   	push   %edx
80101610:	50                   	push   %eax
80101611:	e8 fa fc ff ff       	call   80101310 <readsb>
80101616:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
80101619:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101620:	e9 95 00 00 00       	jmp    801016ba <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum));
80101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101628:	c1 e8 03             	shr    $0x3,%eax
8010162b:	83 c0 02             	add    $0x2,%eax
8010162e:	83 ec 08             	sub    $0x8,%esp
80101631:	50                   	push   %eax
80101632:	ff 75 08             	pushl  0x8(%ebp)
80101635:	e8 7b eb ff ff       	call   801001b5 <bread>
8010163a:	83 c4 10             	add    $0x10,%esp
8010163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101640:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101643:	83 c0 18             	add    $0x18,%eax
80101646:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101649:	83 e2 07             	and    $0x7,%edx
8010164c:	c1 e2 06             	shl    $0x6,%edx
8010164f:	01 d0                	add    %edx,%eax
80101651:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101654:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101657:	8b 00                	mov    (%eax),%eax
80101659:	66 85 c0             	test   %ax,%ax
8010165c:	75 4b                	jne    801016a9 <ialloc+0xb0>
      memset(dip, 0, sizeof(*dip));
8010165e:	83 ec 04             	sub    $0x4,%esp
80101661:	6a 40                	push   $0x40
80101663:	6a 00                	push   $0x0
80101665:	ff 75 ec             	pushl  -0x14(%ebp)
80101668:	e8 6d 37 00 00       	call   80104dda <memset>
8010166d:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101670:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101673:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101676:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101679:	83 ec 0c             	sub    $0xc,%esp
8010167c:	ff 75 f0             	pushl  -0x10(%ebp)
8010167f:	e8 3d 1c 00 00       	call   801032c1 <log_write>
80101684:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101687:	83 ec 0c             	sub    $0xc,%esp
8010168a:	ff 75 f0             	pushl  -0x10(%ebp)
8010168d:	e8 9a eb ff ff       	call   8010022c <brelse>
80101692:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101698:	83 ec 08             	sub    $0x8,%esp
8010169b:	50                   	push   %eax
8010169c:	ff 75 08             	pushl  0x8(%ebp)
8010169f:	e8 ec 00 00 00       	call   80101790 <iget>
801016a4:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801016a7:	c9                   	leave  
801016a8:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801016a9:	83 ec 0c             	sub    $0xc,%esp
801016ac:	ff 75 f0             	pushl  -0x10(%ebp)
801016af:	e8 78 eb ff ff       	call   8010022c <brelse>
801016b4:	83 c4 10             	add    $0x10,%esp
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016b7:	ff 45 f4             	incl   -0xc(%ebp)
801016ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016c0:	39 c2                	cmp    %eax,%edx
801016c2:	0f 82 5d ff ff ff    	jb     80101625 <ialloc+0x2c>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016c8:	83 ec 0c             	sub    $0xc,%esp
801016cb:	68 a1 80 10 80       	push   $0x801080a1
801016d0:	e8 8a ee ff ff       	call   8010055f <panic>

801016d5 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016d5:	55                   	push   %ebp
801016d6:	89 e5                	mov    %esp,%ebp
801016d8:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016db:	8b 45 08             	mov    0x8(%ebp),%eax
801016de:	8b 40 04             	mov    0x4(%eax),%eax
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	8d 50 02             	lea    0x2(%eax),%edx
801016e7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ea:	8b 00                	mov    (%eax),%eax
801016ec:	83 ec 08             	sub    $0x8,%esp
801016ef:	52                   	push   %edx
801016f0:	50                   	push   %eax
801016f1:	e8 bf ea ff ff       	call   801001b5 <bread>
801016f6:	83 c4 10             	add    $0x10,%esp
801016f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ff:	83 c0 18             	add    $0x18,%eax
80101702:	89 c2                	mov    %eax,%edx
80101704:	8b 45 08             	mov    0x8(%ebp),%eax
80101707:	8b 40 04             	mov    0x4(%eax),%eax
8010170a:	83 e0 07             	and    $0x7,%eax
8010170d:	c1 e0 06             	shl    $0x6,%eax
80101710:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101716:	8b 45 08             	mov    0x8(%ebp),%eax
80101719:	8b 40 10             	mov    0x10(%eax),%eax
8010171c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010171f:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
80101722:	8b 45 08             	mov    0x8(%ebp),%eax
80101725:	66 8b 40 12          	mov    0x12(%eax),%ax
80101729:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010172c:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
80101730:	8b 45 08             	mov    0x8(%ebp),%eax
80101733:	8b 40 14             	mov    0x14(%eax),%eax
80101736:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101739:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
8010173d:	8b 45 08             	mov    0x8(%ebp),%eax
80101740:	66 8b 40 16          	mov    0x16(%eax),%ax
80101744:	8b 55 f0             	mov    -0x10(%ebp),%edx
80101747:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
8010174b:	8b 45 08             	mov    0x8(%ebp),%eax
8010174e:	8b 50 18             	mov    0x18(%eax),%edx
80101751:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101754:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101757:	8b 45 08             	mov    0x8(%ebp),%eax
8010175a:	8d 50 1c             	lea    0x1c(%eax),%edx
8010175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101760:	83 c0 0c             	add    $0xc,%eax
80101763:	83 ec 04             	sub    $0x4,%esp
80101766:	6a 34                	push   $0x34
80101768:	52                   	push   %edx
80101769:	50                   	push   %eax
8010176a:	e8 27 37 00 00       	call   80104e96 <memmove>
8010176f:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101772:	83 ec 0c             	sub    $0xc,%esp
80101775:	ff 75 f4             	pushl  -0xc(%ebp)
80101778:	e8 44 1b 00 00       	call   801032c1 <log_write>
8010177d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101780:	83 ec 0c             	sub    $0xc,%esp
80101783:	ff 75 f4             	pushl  -0xc(%ebp)
80101786:	e8 a1 ea ff ff       	call   8010022c <brelse>
8010178b:	83 c4 10             	add    $0x10,%esp
}
8010178e:	c9                   	leave  
8010178f:	c3                   	ret    

80101790 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101796:	83 ec 0c             	sub    $0xc,%esp
80101799:	68 60 e8 10 80       	push   $0x8010e860
8010179e:	e8 e4 33 00 00       	call   80104b87 <acquire>
801017a3:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801017a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017ad:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
801017b4:	eb 5d                	jmp    80101813 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b9:	8b 40 08             	mov    0x8(%eax),%eax
801017bc:	85 c0                	test   %eax,%eax
801017be:	7e 39                	jle    801017f9 <iget+0x69>
801017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c3:	8b 00                	mov    (%eax),%eax
801017c5:	3b 45 08             	cmp    0x8(%ebp),%eax
801017c8:	75 2f                	jne    801017f9 <iget+0x69>
801017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017cd:	8b 40 04             	mov    0x4(%eax),%eax
801017d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017d3:	75 24                	jne    801017f9 <iget+0x69>
      ip->ref++;
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	8b 40 08             	mov    0x8(%eax),%eax
801017db:	8d 50 01             	lea    0x1(%eax),%edx
801017de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e1:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	68 60 e8 10 80       	push   $0x8010e860
801017ec:	e8 fc 33 00 00       	call   80104bed <release>
801017f1:	83 c4 10             	add    $0x10,%esp
      return ip;
801017f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f7:	eb 75                	jmp    8010186e <iget+0xde>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017fd:	75 10                	jne    8010180f <iget+0x7f>
801017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101802:	8b 40 08             	mov    0x8(%eax),%eax
80101805:	85 c0                	test   %eax,%eax
80101807:	75 06                	jne    8010180f <iget+0x7f>
      empty = ip;
80101809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101813:	b8 34 f8 10 80       	mov    $0x8010f834,%eax
80101818:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010181b:	72 99                	jb     801017b6 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010181d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101821:	75 0d                	jne    80101830 <iget+0xa0>
    panic("iget: no inodes");
80101823:	83 ec 0c             	sub    $0xc,%esp
80101826:	68 b3 80 10 80       	push   $0x801080b3
8010182b:	e8 2f ed ff ff       	call   8010055f <panic>

  ip = empty;
80101830:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101839:	8b 55 08             	mov    0x8(%ebp),%edx
8010183c:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101841:	8b 55 0c             	mov    0xc(%ebp),%edx
80101844:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101854:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
8010185b:	83 ec 0c             	sub    $0xc,%esp
8010185e:	68 60 e8 10 80       	push   $0x8010e860
80101863:	e8 85 33 00 00       	call   80104bed <release>
80101868:	83 c4 10             	add    $0x10,%esp

  return ip;
8010186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010186e:	c9                   	leave  
8010186f:	c3                   	ret    

80101870 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	68 60 e8 10 80       	push   $0x8010e860
8010187e:	e8 04 33 00 00       	call   80104b87 <acquire>
80101883:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101886:	8b 45 08             	mov    0x8(%ebp),%eax
80101889:	8b 40 08             	mov    0x8(%eax),%eax
8010188c:	8d 50 01             	lea    0x1(%eax),%edx
8010188f:	8b 45 08             	mov    0x8(%ebp),%eax
80101892:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101895:	83 ec 0c             	sub    $0xc,%esp
80101898:	68 60 e8 10 80       	push   $0x8010e860
8010189d:	e8 4b 33 00 00       	call   80104bed <release>
801018a2:	83 c4 10             	add    $0x10,%esp
  return ip;
801018a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801018a8:	c9                   	leave  
801018a9:	c3                   	ret    

801018aa <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018aa:	55                   	push   %ebp
801018ab:	89 e5                	mov    %esp,%ebp
801018ad:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801018b4:	74 0a                	je     801018c0 <ilock+0x16>
801018b6:	8b 45 08             	mov    0x8(%ebp),%eax
801018b9:	8b 40 08             	mov    0x8(%eax),%eax
801018bc:	85 c0                	test   %eax,%eax
801018be:	7f 0d                	jg     801018cd <ilock+0x23>
    panic("ilock");
801018c0:	83 ec 0c             	sub    $0xc,%esp
801018c3:	68 c3 80 10 80       	push   $0x801080c3
801018c8:	e8 92 ec ff ff       	call   8010055f <panic>

  acquire(&icache.lock);
801018cd:	83 ec 0c             	sub    $0xc,%esp
801018d0:	68 60 e8 10 80       	push   $0x8010e860
801018d5:	e8 ad 32 00 00       	call   80104b87 <acquire>
801018da:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801018dd:	eb 13                	jmp    801018f2 <ilock+0x48>
    sleep(ip, &icache.lock);
801018df:	83 ec 08             	sub    $0x8,%esp
801018e2:	68 60 e8 10 80       	push   $0x8010e860
801018e7:	ff 75 08             	pushl  0x8(%ebp)
801018ea:	e8 95 2f 00 00       	call   80104884 <sleep>
801018ef:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018f2:	8b 45 08             	mov    0x8(%ebp),%eax
801018f5:	8b 40 0c             	mov    0xc(%eax),%eax
801018f8:	83 e0 01             	and    $0x1,%eax
801018fb:	84 c0                	test   %al,%al
801018fd:	75 e0                	jne    801018df <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101902:	8b 40 0c             	mov    0xc(%eax),%eax
80101905:	89 c2                	mov    %eax,%edx
80101907:	83 ca 01             	or     $0x1,%edx
8010190a:	8b 45 08             	mov    0x8(%ebp),%eax
8010190d:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101910:	83 ec 0c             	sub    $0xc,%esp
80101913:	68 60 e8 10 80       	push   $0x8010e860
80101918:	e8 d0 32 00 00       	call   80104bed <release>
8010191d:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101920:	8b 45 08             	mov    0x8(%ebp),%eax
80101923:	8b 40 0c             	mov    0xc(%eax),%eax
80101926:	83 e0 02             	and    $0x2,%eax
80101929:	85 c0                	test   %eax,%eax
8010192b:	0f 85 ce 00 00 00    	jne    801019ff <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	8b 40 04             	mov    0x4(%eax),%eax
80101937:	c1 e8 03             	shr    $0x3,%eax
8010193a:	8d 50 02             	lea    0x2(%eax),%edx
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	8b 00                	mov    (%eax),%eax
80101942:	83 ec 08             	sub    $0x8,%esp
80101945:	52                   	push   %edx
80101946:	50                   	push   %eax
80101947:	e8 69 e8 ff ff       	call   801001b5 <bread>
8010194c:	83 c4 10             	add    $0x10,%esp
8010194f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101952:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101955:	83 c0 18             	add    $0x18,%eax
80101958:	89 c2                	mov    %eax,%edx
8010195a:	8b 45 08             	mov    0x8(%ebp),%eax
8010195d:	8b 40 04             	mov    0x4(%eax),%eax
80101960:	83 e0 07             	and    $0x7,%eax
80101963:	c1 e0 06             	shl    $0x6,%eax
80101966:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101969:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010196c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010196f:	8b 00                	mov    (%eax),%eax
80101971:	8b 55 08             	mov    0x8(%ebp),%edx
80101974:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
80101978:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010197b:	66 8b 40 02          	mov    0x2(%eax),%ax
8010197f:	8b 55 08             	mov    0x8(%ebp),%edx
80101982:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101986:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101989:	8b 40 04             	mov    0x4(%eax),%eax
8010198c:	8b 55 08             	mov    0x8(%ebp),%edx
8010198f:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101993:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101996:	66 8b 40 06          	mov    0x6(%eax),%ax
8010199a:	8b 55 08             	mov    0x8(%ebp),%edx
8010199d:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
801019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a4:	8b 50 08             	mov    0x8(%eax),%edx
801019a7:	8b 45 08             	mov    0x8(%ebp),%eax
801019aa:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b0:	8d 50 0c             	lea    0xc(%eax),%edx
801019b3:	8b 45 08             	mov    0x8(%ebp),%eax
801019b6:	83 c0 1c             	add    $0x1c,%eax
801019b9:	83 ec 04             	sub    $0x4,%esp
801019bc:	6a 34                	push   $0x34
801019be:	52                   	push   %edx
801019bf:	50                   	push   %eax
801019c0:	e8 d1 34 00 00       	call   80104e96 <memmove>
801019c5:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801019c8:	83 ec 0c             	sub    $0xc,%esp
801019cb:	ff 75 f4             	pushl  -0xc(%ebp)
801019ce:	e8 59 e8 ff ff       	call   8010022c <brelse>
801019d3:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	8b 40 0c             	mov    0xc(%eax),%eax
801019dc:	89 c2                	mov    %eax,%edx
801019de:	83 ca 02             	or     $0x2,%edx
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	8b 40 10             	mov    0x10(%eax),%eax
801019ed:	66 85 c0             	test   %ax,%ax
801019f0:	75 0d                	jne    801019ff <ilock+0x155>
      panic("ilock: no type");
801019f2:	83 ec 0c             	sub    $0xc,%esp
801019f5:	68 c9 80 10 80       	push   $0x801080c9
801019fa:	e8 60 eb ff ff       	call   8010055f <panic>
  }
}
801019ff:	c9                   	leave  
80101a00:	c3                   	ret    

80101a01 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a01:	55                   	push   %ebp
80101a02:	89 e5                	mov    %esp,%ebp
80101a04:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a0b:	74 17                	je     80101a24 <iunlock+0x23>
80101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a10:	8b 40 0c             	mov    0xc(%eax),%eax
80101a13:	83 e0 01             	and    $0x1,%eax
80101a16:	85 c0                	test   %eax,%eax
80101a18:	74 0a                	je     80101a24 <iunlock+0x23>
80101a1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1d:	8b 40 08             	mov    0x8(%eax),%eax
80101a20:	85 c0                	test   %eax,%eax
80101a22:	7f 0d                	jg     80101a31 <iunlock+0x30>
    panic("iunlock");
80101a24:	83 ec 0c             	sub    $0xc,%esp
80101a27:	68 d8 80 10 80       	push   $0x801080d8
80101a2c:	e8 2e eb ff ff       	call   8010055f <panic>

  acquire(&icache.lock);
80101a31:	83 ec 0c             	sub    $0xc,%esp
80101a34:	68 60 e8 10 80       	push   $0x8010e860
80101a39:	e8 49 31 00 00       	call   80104b87 <acquire>
80101a3e:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101a41:	8b 45 08             	mov    0x8(%ebp),%eax
80101a44:	8b 40 0c             	mov    0xc(%eax),%eax
80101a47:	89 c2                	mov    %eax,%edx
80101a49:	83 e2 fe             	and    $0xfffffffe,%edx
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a52:	83 ec 0c             	sub    $0xc,%esp
80101a55:	ff 75 08             	pushl  0x8(%ebp)
80101a58:	e8 11 2f 00 00       	call   8010496e <wakeup>
80101a5d:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	68 60 e8 10 80       	push   $0x8010e860
80101a68:	e8 80 31 00 00       	call   80104bed <release>
80101a6d:	83 c4 10             	add    $0x10,%esp
}
80101a70:	c9                   	leave  
80101a71:	c3                   	ret    

80101a72 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a72:	55                   	push   %ebp
80101a73:	89 e5                	mov    %esp,%ebp
80101a75:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a78:	83 ec 0c             	sub    $0xc,%esp
80101a7b:	68 60 e8 10 80       	push   $0x8010e860
80101a80:	e8 02 31 00 00       	call   80104b87 <acquire>
80101a85:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 08             	mov    0x8(%eax),%eax
80101a8e:	83 f8 01             	cmp    $0x1,%eax
80101a91:	0f 85 a9 00 00 00    	jne    80101b40 <iput+0xce>
80101a97:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9a:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9d:	83 e0 02             	and    $0x2,%eax
80101aa0:	85 c0                	test   %eax,%eax
80101aa2:	0f 84 98 00 00 00    	je     80101b40 <iput+0xce>
80101aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101aab:	66 8b 40 16          	mov    0x16(%eax),%ax
80101aaf:	66 85 c0             	test   %ax,%ax
80101ab2:	0f 85 88 00 00 00    	jne    80101b40 <iput+0xce>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80101abb:	8b 40 0c             	mov    0xc(%eax),%eax
80101abe:	83 e0 01             	and    $0x1,%eax
80101ac1:	84 c0                	test   %al,%al
80101ac3:	74 0d                	je     80101ad2 <iput+0x60>
      panic("iput busy");
80101ac5:	83 ec 0c             	sub    $0xc,%esp
80101ac8:	68 e0 80 10 80       	push   $0x801080e0
80101acd:	e8 8d ea ff ff       	call   8010055f <panic>
    ip->flags |= I_BUSY;
80101ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad5:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad8:	89 c2                	mov    %eax,%edx
80101ada:	83 ca 01             	or     $0x1,%edx
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ae3:	83 ec 0c             	sub    $0xc,%esp
80101ae6:	68 60 e8 10 80       	push   $0x8010e860
80101aeb:	e8 fd 30 00 00       	call   80104bed <release>
80101af0:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101af3:	83 ec 0c             	sub    $0xc,%esp
80101af6:	ff 75 08             	pushl  0x8(%ebp)
80101af9:	e8 9b 01 00 00       	call   80101c99 <itrunc>
80101afe:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b01:	8b 45 08             	mov    0x8(%ebp),%eax
80101b04:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b0a:	83 ec 0c             	sub    $0xc,%esp
80101b0d:	ff 75 08             	pushl  0x8(%ebp)
80101b10:	e8 c0 fb ff ff       	call   801016d5 <iupdate>
80101b15:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b18:	83 ec 0c             	sub    $0xc,%esp
80101b1b:	68 60 e8 10 80       	push   $0x8010e860
80101b20:	e8 62 30 00 00       	call   80104b87 <acquire>
80101b25:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101b32:	83 ec 0c             	sub    $0xc,%esp
80101b35:	ff 75 08             	pushl  0x8(%ebp)
80101b38:	e8 31 2e 00 00       	call   8010496e <wakeup>
80101b3d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101b40:	8b 45 08             	mov    0x8(%ebp),%eax
80101b43:	8b 40 08             	mov    0x8(%eax),%eax
80101b46:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b4f:	83 ec 0c             	sub    $0xc,%esp
80101b52:	68 60 e8 10 80       	push   $0x8010e860
80101b57:	e8 91 30 00 00       	call   80104bed <release>
80101b5c:	83 c4 10             	add    $0x10,%esp
}
80101b5f:	c9                   	leave  
80101b60:	c3                   	ret    

80101b61 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	ff 75 08             	pushl  0x8(%ebp)
80101b6d:	e8 8f fe ff ff       	call   80101a01 <iunlock>
80101b72:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101b75:	83 ec 0c             	sub    $0xc,%esp
80101b78:	ff 75 08             	pushl  0x8(%ebp)
80101b7b:	e8 f2 fe ff ff       	call   80101a72 <iput>
80101b80:	83 c4 10             	add    $0x10,%esp
}
80101b83:	c9                   	leave  
80101b84:	c3                   	ret    

80101b85 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b85:	55                   	push   %ebp
80101b86:	89 e5                	mov    %esp,%ebp
80101b88:	53                   	push   %ebx
80101b89:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b8c:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b90:	77 42                	ja     80101bd4 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101b92:	8b 45 08             	mov    0x8(%ebp),%eax
80101b95:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b98:	83 c2 04             	add    $0x4,%edx
80101b9b:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ba2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ba6:	75 24                	jne    80101bcc <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bab:	8b 00                	mov    (%eax),%eax
80101bad:	83 ec 0c             	sub    $0xc,%esp
80101bb0:	50                   	push   %eax
80101bb1:	e8 ee f7 ff ff       	call   801013a4 <balloc>
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bc2:	8d 4a 04             	lea    0x4(%edx),%ecx
80101bc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bc8:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bcf:	e9 c0 00 00 00       	jmp    80101c94 <bmap+0x10f>
  }
  bn -= NDIRECT;
80101bd4:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bd8:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bdc:	0f 87 a5 00 00 00    	ja     80101c87 <bmap+0x102>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101be2:	8b 45 08             	mov    0x8(%ebp),%eax
80101be5:	8b 40 4c             	mov    0x4c(%eax),%eax
80101be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bef:	75 1d                	jne    80101c0e <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf4:	8b 00                	mov    (%eax),%eax
80101bf6:	83 ec 0c             	sub    $0xc,%esp
80101bf9:	50                   	push   %eax
80101bfa:	e8 a5 f7 ff ff       	call   801013a4 <balloc>
80101bff:	83 c4 10             	add    $0x10,%esp
80101c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c05:	8b 45 08             	mov    0x8(%ebp),%eax
80101c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0b:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c11:	8b 00                	mov    (%eax),%eax
80101c13:	83 ec 08             	sub    $0x8,%esp
80101c16:	ff 75 f4             	pushl  -0xc(%ebp)
80101c19:	50                   	push   %eax
80101c1a:	e8 96 e5 ff ff       	call   801001b5 <bread>
80101c1f:	83 c4 10             	add    $0x10,%esp
80101c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c28:	83 c0 18             	add    $0x18,%eax
80101c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c31:	c1 e0 02             	shl    $0x2,%eax
80101c34:	03 45 ec             	add    -0x14(%ebp),%eax
80101c37:	8b 00                	mov    (%eax),%eax
80101c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c40:	75 32                	jne    80101c74 <bmap+0xef>
      a[bn] = addr = balloc(ip->dev);
80101c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c45:	c1 e0 02             	shl    $0x2,%eax
80101c48:	89 c3                	mov    %eax,%ebx
80101c4a:	03 5d ec             	add    -0x14(%ebp),%ebx
80101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c50:	8b 00                	mov    (%eax),%eax
80101c52:	83 ec 0c             	sub    $0xc,%esp
80101c55:	50                   	push   %eax
80101c56:	e8 49 f7 ff ff       	call   801013a4 <balloc>
80101c5b:	83 c4 10             	add    $0x10,%esp
80101c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c64:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c66:	83 ec 0c             	sub    $0xc,%esp
80101c69:	ff 75 f0             	pushl  -0x10(%ebp)
80101c6c:	e8 50 16 00 00       	call   801032c1 <log_write>
80101c71:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101c74:	83 ec 0c             	sub    $0xc,%esp
80101c77:	ff 75 f0             	pushl  -0x10(%ebp)
80101c7a:	e8 ad e5 ff ff       	call   8010022c <brelse>
80101c7f:	83 c4 10             	add    $0x10,%esp
    return addr;
80101c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c85:	eb 0d                	jmp    80101c94 <bmap+0x10f>
  }

  panic("bmap: out of range");
80101c87:	83 ec 0c             	sub    $0xc,%esp
80101c8a:	68 ea 80 10 80       	push   $0x801080ea
80101c8f:	e8 cb e8 ff ff       	call   8010055f <panic>
}
80101c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c97:	c9                   	leave  
80101c98:	c3                   	ret    

80101c99 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c99:	55                   	push   %ebp
80101c9a:	89 e5                	mov    %esp,%ebp
80101c9c:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ca6:	eb 44                	jmp    80101cec <itrunc+0x53>
    if(ip->addrs[i]){
80101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cae:	83 c2 04             	add    $0x4,%edx
80101cb1:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 30                	je     80101ce9 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cbf:	83 c2 04             	add    $0x4,%edx
80101cc2:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc9:	8b 00                	mov    (%eax),%eax
80101ccb:	83 ec 08             	sub    $0x8,%esp
80101cce:	52                   	push   %edx
80101ccf:	50                   	push   %eax
80101cd0:	e8 2b f8 ff ff       	call   80101500 <bfree>
80101cd5:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101cd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cde:	83 c2 04             	add    $0x4,%edx
80101ce1:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101ce8:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ce9:	ff 45 f4             	incl   -0xc(%ebp)
80101cec:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cf0:	7e b6                	jle    80101ca8 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf5:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cf8:	85 c0                	test   %eax,%eax
80101cfa:	0f 84 94 00 00 00    	je     80101d94 <itrunc+0xfb>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d00:	8b 45 08             	mov    0x8(%ebp),%eax
80101d03:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d06:	8b 45 08             	mov    0x8(%ebp),%eax
80101d09:	8b 00                	mov    (%eax),%eax
80101d0b:	83 ec 08             	sub    $0x8,%esp
80101d0e:	52                   	push   %edx
80101d0f:	50                   	push   %eax
80101d10:	e8 a0 e4 ff ff       	call   801001b5 <bread>
80101d15:	83 c4 10             	add    $0x10,%esp
80101d18:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1e:	83 c0 18             	add    $0x18,%eax
80101d21:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d2b:	eb 2f                	jmp    80101d5c <itrunc+0xc3>
      if(a[j])
80101d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d30:	c1 e0 02             	shl    $0x2,%eax
80101d33:	03 45 e8             	add    -0x18(%ebp),%eax
80101d36:	8b 00                	mov    (%eax),%eax
80101d38:	85 c0                	test   %eax,%eax
80101d3a:	74 1d                	je     80101d59 <itrunc+0xc0>
        bfree(ip->dev, a[j]);
80101d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d3f:	c1 e0 02             	shl    $0x2,%eax
80101d42:	03 45 e8             	add    -0x18(%ebp),%eax
80101d45:	8b 10                	mov    (%eax),%edx
80101d47:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4a:	8b 00                	mov    (%eax),%eax
80101d4c:	83 ec 08             	sub    $0x8,%esp
80101d4f:	52                   	push   %edx
80101d50:	50                   	push   %eax
80101d51:	e8 aa f7 ff ff       	call   80101500 <bfree>
80101d56:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d59:	ff 45 f0             	incl   -0x10(%ebp)
80101d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d5f:	83 f8 7f             	cmp    $0x7f,%eax
80101d62:	76 c9                	jbe    80101d2d <itrunc+0x94>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	ff 75 ec             	pushl  -0x14(%ebp)
80101d6a:	e8 bd e4 ff ff       	call   8010022c <brelse>
80101d6f:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d72:	8b 45 08             	mov    0x8(%ebp),%eax
80101d75:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d78:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7b:	8b 00                	mov    (%eax),%eax
80101d7d:	83 ec 08             	sub    $0x8,%esp
80101d80:	52                   	push   %edx
80101d81:	50                   	push   %eax
80101d82:	e8 79 f7 ff ff       	call   80101500 <bfree>
80101d87:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	ff 75 08             	pushl  0x8(%ebp)
80101da4:	e8 2c f9 ff ff       	call   801016d5 <iupdate>
80101da9:	83 c4 10             	add    $0x10,%esp
}
80101dac:	c9                   	leave  
80101dad:	c3                   	ret    

80101dae <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101dae:	55                   	push   %ebp
80101daf:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101db1:	8b 45 08             	mov    0x8(%ebp),%eax
80101db4:	8b 00                	mov    (%eax),%eax
80101db6:	89 c2                	mov    %eax,%edx
80101db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbb:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 50 04             	mov    0x4(%eax),%edx
80101dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc7:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dca:	8b 45 08             	mov    0x8(%ebp),%eax
80101dcd:	8b 40 10             	mov    0x10(%eax),%eax
80101dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dd3:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	66 8b 40 16          	mov    0x16(%eax),%ax
80101ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101de0:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	8b 50 18             	mov    0x18(%eax),%edx
80101dea:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ded:	89 50 10             	mov    %edx,0x10(%eax)
}
80101df0:	c9                   	leave  
80101df1:	c3                   	ret    

80101df2 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101df2:	55                   	push   %ebp
80101df3:	89 e5                	mov    %esp,%ebp
80101df5:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101df8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dfb:	8b 40 10             	mov    0x10(%eax),%eax
80101dfe:	66 83 f8 03          	cmp    $0x3,%ax
80101e02:	75 5c                	jne    80101e60 <readi+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e04:	8b 45 08             	mov    0x8(%ebp),%eax
80101e07:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e0b:	66 85 c0             	test   %ax,%ax
80101e0e:	78 20                	js     80101e30 <readi+0x3e>
80101e10:	8b 45 08             	mov    0x8(%ebp),%eax
80101e13:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e17:	66 83 f8 09          	cmp    $0x9,%ax
80101e1b:	7f 13                	jg     80101e30 <readi+0x3e>
80101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e20:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e24:	98                   	cwtl   
80101e25:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101e2c:	85 c0                	test   %eax,%eax
80101e2e:	75 0a                	jne    80101e3a <readi+0x48>
      return -1;
80101e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e35:	e9 16 01 00 00       	jmp    80101f50 <readi+0x15e>
    return devsw[ip->major].read(ip, dst, n);
80101e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e3d:	66 8b 40 12          	mov    0x12(%eax),%ax
80101e41:	98                   	cwtl   
80101e42:	8b 14 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%edx
80101e49:	8b 45 14             	mov    0x14(%ebp),%eax
80101e4c:	83 ec 04             	sub    $0x4,%esp
80101e4f:	50                   	push   %eax
80101e50:	ff 75 0c             	pushl  0xc(%ebp)
80101e53:	ff 75 08             	pushl  0x8(%ebp)
80101e56:	ff d2                	call   *%edx
80101e58:	83 c4 10             	add    $0x10,%esp
80101e5b:	e9 f0 00 00 00       	jmp    80101f50 <readi+0x15e>
  }

  if(off > ip->size || off + n < off)
80101e60:	8b 45 08             	mov    0x8(%ebp),%eax
80101e63:	8b 40 18             	mov    0x18(%eax),%eax
80101e66:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e69:	72 0e                	jb     80101e79 <readi+0x87>
80101e6b:	8b 45 14             	mov    0x14(%ebp),%eax
80101e6e:	8b 55 10             	mov    0x10(%ebp),%edx
80101e71:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101e74:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e77:	73 0a                	jae    80101e83 <readi+0x91>
    return -1;
80101e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e7e:	e9 cd 00 00 00       	jmp    80101f50 <readi+0x15e>
  if(off + n > ip->size)
80101e83:	8b 45 14             	mov    0x14(%ebp),%eax
80101e86:	8b 55 10             	mov    0x10(%ebp),%edx
80101e89:	01 c2                	add    %eax,%edx
80101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8e:	8b 40 18             	mov    0x18(%eax),%eax
80101e91:	39 c2                	cmp    %eax,%edx
80101e93:	76 0c                	jbe    80101ea1 <readi+0xaf>
    n = ip->size - off;
80101e95:	8b 45 08             	mov    0x8(%ebp),%eax
80101e98:	8b 40 18             	mov    0x18(%eax),%eax
80101e9b:	2b 45 10             	sub    0x10(%ebp),%eax
80101e9e:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101ea8:	e9 94 00 00 00       	jmp    80101f41 <readi+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ead:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb0:	c1 e8 09             	shr    $0x9,%eax
80101eb3:	83 ec 08             	sub    $0x8,%esp
80101eb6:	50                   	push   %eax
80101eb7:	ff 75 08             	pushl  0x8(%ebp)
80101eba:	e8 c6 fc ff ff       	call   80101b85 <bmap>
80101ebf:	83 c4 10             	add    $0x10,%esp
80101ec2:	8b 55 08             	mov    0x8(%ebp),%edx
80101ec5:	8b 12                	mov    (%edx),%edx
80101ec7:	83 ec 08             	sub    $0x8,%esp
80101eca:	50                   	push   %eax
80101ecb:	52                   	push   %edx
80101ecc:	e8 e4 e2 ff ff       	call   801001b5 <bread>
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ed7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eda:	89 c2                	mov    %eax,%edx
80101edc:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101ee2:	b8 00 02 00 00       	mov    $0x200,%eax
80101ee7:	89 c1                	mov    %eax,%ecx
80101ee9:	29 d1                	sub    %edx,%ecx
80101eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eee:	8b 55 14             	mov    0x14(%ebp),%edx
80101ef1:	29 c2                	sub    %eax,%edx
80101ef3:	89 c8                	mov    %ecx,%eax
80101ef5:	39 d0                	cmp    %edx,%eax
80101ef7:	76 02                	jbe    80101efb <readi+0x109>
80101ef9:	89 d0                	mov    %edx,%eax
80101efb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f01:	8d 50 18             	lea    0x18(%eax),%edx
80101f04:	8b 45 10             	mov    0x10(%ebp),%eax
80101f07:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f0c:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101f0f:	83 ec 04             	sub    $0x4,%esp
80101f12:	ff 75 ec             	pushl  -0x14(%ebp)
80101f15:	50                   	push   %eax
80101f16:	ff 75 0c             	pushl  0xc(%ebp)
80101f19:	e8 78 2f 00 00       	call   80104e96 <memmove>
80101f1e:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101f21:	83 ec 0c             	sub    $0xc,%esp
80101f24:	ff 75 f0             	pushl  -0x10(%ebp)
80101f27:	e8 00 e3 ff ff       	call   8010022c <brelse>
80101f2c:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f32:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f38:	01 45 10             	add    %eax,0x10(%ebp)
80101f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f3e:	01 45 0c             	add    %eax,0xc(%ebp)
80101f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f44:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f47:	0f 82 60 ff ff ff    	jb     80101ead <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f4d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f50:	c9                   	leave  
80101f51:	c3                   	ret    

80101f52 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f52:	55                   	push   %ebp
80101f53:	89 e5                	mov    %esp,%ebp
80101f55:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8b 40 10             	mov    0x10(%eax),%eax
80101f5e:	66 83 f8 03          	cmp    $0x3,%ax
80101f62:	75 5c                	jne    80101fc0 <writei+0x6e>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f64:	8b 45 08             	mov    0x8(%ebp),%eax
80101f67:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f6b:	66 85 c0             	test   %ax,%ax
80101f6e:	78 20                	js     80101f90 <writei+0x3e>
80101f70:	8b 45 08             	mov    0x8(%ebp),%eax
80101f73:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f77:	66 83 f8 09          	cmp    $0x9,%ax
80101f7b:	7f 13                	jg     80101f90 <writei+0x3e>
80101f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f80:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f84:	98                   	cwtl   
80101f85:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f8c:	85 c0                	test   %eax,%eax
80101f8e:	75 0a                	jne    80101f9a <writei+0x48>
      return -1;
80101f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f95:	e9 48 01 00 00       	jmp    801020e2 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101f9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9d:	66 8b 40 12          	mov    0x12(%eax),%ax
80101fa1:	98                   	cwtl   
80101fa2:	8b 14 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%edx
80101fa9:	8b 45 14             	mov    0x14(%ebp),%eax
80101fac:	83 ec 04             	sub    $0x4,%esp
80101faf:	50                   	push   %eax
80101fb0:	ff 75 0c             	pushl  0xc(%ebp)
80101fb3:	ff 75 08             	pushl  0x8(%ebp)
80101fb6:	ff d2                	call   *%edx
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	e9 22 01 00 00       	jmp    801020e2 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80101fc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc3:	8b 40 18             	mov    0x18(%eax),%eax
80101fc6:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fc9:	72 0e                	jb     80101fd9 <writei+0x87>
80101fcb:	8b 45 14             	mov    0x14(%ebp),%eax
80101fce:	8b 55 10             	mov    0x10(%ebp),%edx
80101fd1:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101fd4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fd7:	73 0a                	jae    80101fe3 <writei+0x91>
    return -1;
80101fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fde:	e9 ff 00 00 00       	jmp    801020e2 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
80101fe3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fe6:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe9:	8d 04 02             	lea    (%edx,%eax,1),%eax
80101fec:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ff1:	76 0a                	jbe    80101ffd <writei+0xab>
    return -1;
80101ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ff8:	e9 e5 00 00 00       	jmp    801020e2 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ffd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102004:	e9 a2 00 00 00       	jmp    801020ab <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102009:	8b 45 10             	mov    0x10(%ebp),%eax
8010200c:	c1 e8 09             	shr    $0x9,%eax
8010200f:	83 ec 08             	sub    $0x8,%esp
80102012:	50                   	push   %eax
80102013:	ff 75 08             	pushl  0x8(%ebp)
80102016:	e8 6a fb ff ff       	call   80101b85 <bmap>
8010201b:	83 c4 10             	add    $0x10,%esp
8010201e:	8b 55 08             	mov    0x8(%ebp),%edx
80102021:	8b 12                	mov    (%edx),%edx
80102023:	83 ec 08             	sub    $0x8,%esp
80102026:	50                   	push   %eax
80102027:	52                   	push   %edx
80102028:	e8 88 e1 ff ff       	call   801001b5 <bread>
8010202d:	83 c4 10             	add    $0x10,%esp
80102030:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102033:	8b 45 10             	mov    0x10(%ebp),%eax
80102036:	89 c2                	mov    %eax,%edx
80102038:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010203e:	b8 00 02 00 00       	mov    $0x200,%eax
80102043:	89 c1                	mov    %eax,%ecx
80102045:	29 d1                	sub    %edx,%ecx
80102047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010204a:	8b 55 14             	mov    0x14(%ebp),%edx
8010204d:	29 c2                	sub    %eax,%edx
8010204f:	89 c8                	mov    %ecx,%eax
80102051:	39 d0                	cmp    %edx,%eax
80102053:	76 02                	jbe    80102057 <writei+0x105>
80102055:	89 d0                	mov    %edx,%eax
80102057:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010205d:	8d 50 18             	lea    0x18(%eax),%edx
80102060:	8b 45 10             	mov    0x10(%ebp),%eax
80102063:	25 ff 01 00 00       	and    $0x1ff,%eax
80102068:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010206b:	83 ec 04             	sub    $0x4,%esp
8010206e:	ff 75 ec             	pushl  -0x14(%ebp)
80102071:	ff 75 0c             	pushl  0xc(%ebp)
80102074:	50                   	push   %eax
80102075:	e8 1c 2e 00 00       	call   80104e96 <memmove>
8010207a:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010207d:	83 ec 0c             	sub    $0xc,%esp
80102080:	ff 75 f0             	pushl  -0x10(%ebp)
80102083:	e8 39 12 00 00       	call   801032c1 <log_write>
80102088:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010208b:	83 ec 0c             	sub    $0xc,%esp
8010208e:	ff 75 f0             	pushl  -0x10(%ebp)
80102091:	e8 96 e1 ff ff       	call   8010022c <brelse>
80102096:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102099:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010209c:	01 45 f4             	add    %eax,-0xc(%ebp)
8010209f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a2:	01 45 10             	add    %eax,0x10(%ebp)
801020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a8:	01 45 0c             	add    %eax,0xc(%ebp)
801020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ae:	3b 45 14             	cmp    0x14(%ebp),%eax
801020b1:	0f 82 52 ff ff ff    	jb     80102009 <writei+0xb7>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801020b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020bb:	74 22                	je     801020df <writei+0x18d>
801020bd:	8b 45 08             	mov    0x8(%ebp),%eax
801020c0:	8b 40 18             	mov    0x18(%eax),%eax
801020c3:	3b 45 10             	cmp    0x10(%ebp),%eax
801020c6:	73 17                	jae    801020df <writei+0x18d>
    ip->size = off;
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	8b 55 10             	mov    0x10(%ebp),%edx
801020ce:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801020d1:	83 ec 0c             	sub    $0xc,%esp
801020d4:	ff 75 08             	pushl  0x8(%ebp)
801020d7:	e8 f9 f5 ff ff       	call   801016d5 <iupdate>
801020dc:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801020df:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020e2:	c9                   	leave  
801020e3:	c3                   	ret    

801020e4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020e4:	55                   	push   %ebp
801020e5:	89 e5                	mov    %esp,%ebp
801020e7:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801020ea:	83 ec 04             	sub    $0x4,%esp
801020ed:	6a 0e                	push   $0xe
801020ef:	ff 75 0c             	pushl  0xc(%ebp)
801020f2:	ff 75 08             	pushl  0x8(%ebp)
801020f5:	e8 31 2e 00 00       	call   80104f2b <strncmp>
801020fa:	83 c4 10             	add    $0x10,%esp
}
801020fd:	c9                   	leave  
801020fe:	c3                   	ret    

801020ff <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020ff:	55                   	push   %ebp
80102100:	89 e5                	mov    %esp,%ebp
80102102:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102105:	8b 45 08             	mov    0x8(%ebp),%eax
80102108:	8b 40 10             	mov    0x10(%eax),%eax
8010210b:	66 83 f8 01          	cmp    $0x1,%ax
8010210f:	74 0d                	je     8010211e <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102111:	83 ec 0c             	sub    $0xc,%esp
80102114:	68 fd 80 10 80       	push   $0x801080fd
80102119:	e8 41 e4 ff ff       	call   8010055f <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010211e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102125:	eb 79                	jmp    801021a0 <dirlookup+0xa1>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102127:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010212a:	6a 10                	push   $0x10
8010212c:	ff 75 f4             	pushl  -0xc(%ebp)
8010212f:	50                   	push   %eax
80102130:	ff 75 08             	pushl  0x8(%ebp)
80102133:	e8 ba fc ff ff       	call   80101df2 <readi>
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	83 f8 10             	cmp    $0x10,%eax
8010213e:	74 0d                	je     8010214d <dirlookup+0x4e>
      panic("dirlink read");
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	68 0f 81 10 80       	push   $0x8010810f
80102148:	e8 12 e4 ff ff       	call   8010055f <panic>
    if(de.inum == 0)
8010214d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102150:	66 85 c0             	test   %ax,%ax
80102153:	74 46                	je     8010219b <dirlookup+0x9c>
      continue;
    if(namecmp(name, de.name) == 0){
80102155:	83 ec 08             	sub    $0x8,%esp
80102158:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010215b:	83 c0 02             	add    $0x2,%eax
8010215e:	50                   	push   %eax
8010215f:	ff 75 0c             	pushl  0xc(%ebp)
80102162:	e8 7d ff ff ff       	call   801020e4 <namecmp>
80102167:	83 c4 10             	add    $0x10,%esp
8010216a:	85 c0                	test   %eax,%eax
8010216c:	75 2e                	jne    8010219c <dirlookup+0x9d>
      // entry matches path element
      if(poff)
8010216e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102172:	74 08                	je     8010217c <dirlookup+0x7d>
        *poff = off;
80102174:	8b 45 10             	mov    0x10(%ebp),%eax
80102177:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010217a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010217c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010217f:	0f b7 c0             	movzwl %ax,%eax
80102182:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102185:	8b 45 08             	mov    0x8(%ebp),%eax
80102188:	8b 00                	mov    (%eax),%eax
8010218a:	83 ec 08             	sub    $0x8,%esp
8010218d:	ff 75 f0             	pushl  -0x10(%ebp)
80102190:	50                   	push   %eax
80102191:	e8 fa f5 ff ff       	call   80101790 <iget>
80102196:	83 c4 10             	add    $0x10,%esp
80102199:	eb 19                	jmp    801021b4 <dirlookup+0xb5>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010219b:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010219c:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021a0:	8b 45 08             	mov    0x8(%ebp),%eax
801021a3:	8b 40 18             	mov    0x18(%eax),%eax
801021a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021a9:	0f 87 78 ff ff ff    	ja     80102127 <dirlookup+0x28>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801021af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021b4:	c9                   	leave  
801021b5:	c3                   	ret    

801021b6 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021b6:	55                   	push   %ebp
801021b7:	89 e5                	mov    %esp,%ebp
801021b9:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021bc:	83 ec 04             	sub    $0x4,%esp
801021bf:	6a 00                	push   $0x0
801021c1:	ff 75 0c             	pushl  0xc(%ebp)
801021c4:	ff 75 08             	pushl  0x8(%ebp)
801021c7:	e8 33 ff ff ff       	call   801020ff <dirlookup>
801021cc:	83 c4 10             	add    $0x10,%esp
801021cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021d6:	74 18                	je     801021f0 <dirlink+0x3a>
    iput(ip);
801021d8:	83 ec 0c             	sub    $0xc,%esp
801021db:	ff 75 f0             	pushl  -0x10(%ebp)
801021de:	e8 8f f8 ff ff       	call   80101a72 <iput>
801021e3:	83 c4 10             	add    $0x10,%esp
    return -1;
801021e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021eb:	e9 9b 00 00 00       	jmp    8010228b <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f7:	eb 38                	jmp    80102231 <dirlink+0x7b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021fc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ff:	6a 10                	push   $0x10
80102201:	52                   	push   %edx
80102202:	50                   	push   %eax
80102203:	ff 75 08             	pushl  0x8(%ebp)
80102206:	e8 e7 fb ff ff       	call   80101df2 <readi>
8010220b:	83 c4 10             	add    $0x10,%esp
8010220e:	83 f8 10             	cmp    $0x10,%eax
80102211:	74 0d                	je     80102220 <dirlink+0x6a>
      panic("dirlink read");
80102213:	83 ec 0c             	sub    $0xc,%esp
80102216:	68 0f 81 10 80       	push   $0x8010810f
8010221b:	e8 3f e3 ff ff       	call   8010055f <panic>
    if(de.inum == 0)
80102220:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102223:	66 85 c0             	test   %ax,%ax
80102226:	74 18                	je     80102240 <dirlink+0x8a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010222b:	83 c0 10             	add    $0x10,%eax
8010222e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102231:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102234:	8b 45 08             	mov    0x8(%ebp),%eax
80102237:	8b 40 18             	mov    0x18(%eax),%eax
8010223a:	39 c2                	cmp    %eax,%edx
8010223c:	72 bb                	jb     801021f9 <dirlink+0x43>
8010223e:	eb 01                	jmp    80102241 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102240:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102241:	83 ec 04             	sub    $0x4,%esp
80102244:	6a 0e                	push   $0xe
80102246:	ff 75 0c             	pushl  0xc(%ebp)
80102249:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010224c:	83 c0 02             	add    $0x2,%eax
8010224f:	50                   	push   %eax
80102250:	e8 26 2d 00 00       	call   80104f7b <strncpy>
80102255:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102258:	8b 45 10             	mov    0x10(%ebp),%eax
8010225b:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010225f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102262:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102265:	6a 10                	push   $0x10
80102267:	52                   	push   %edx
80102268:	50                   	push   %eax
80102269:	ff 75 08             	pushl  0x8(%ebp)
8010226c:	e8 e1 fc ff ff       	call   80101f52 <writei>
80102271:	83 c4 10             	add    $0x10,%esp
80102274:	83 f8 10             	cmp    $0x10,%eax
80102277:	74 0d                	je     80102286 <dirlink+0xd0>
    panic("dirlink");
80102279:	83 ec 0c             	sub    $0xc,%esp
8010227c:	68 1c 81 10 80       	push   $0x8010811c
80102281:	e8 d9 e2 ff ff       	call   8010055f <panic>
  
  return 0;
80102286:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010228b:	c9                   	leave  
8010228c:	c3                   	ret    

8010228d <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010228d:	55                   	push   %ebp
8010228e:	89 e5                	mov    %esp,%ebp
80102290:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102293:	eb 03                	jmp    80102298 <skipelem+0xb>
    path++;
80102295:	ff 45 08             	incl   0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102298:	8b 45 08             	mov    0x8(%ebp),%eax
8010229b:	8a 00                	mov    (%eax),%al
8010229d:	3c 2f                	cmp    $0x2f,%al
8010229f:	74 f4                	je     80102295 <skipelem+0x8>
    path++;
  if(*path == 0)
801022a1:	8b 45 08             	mov    0x8(%ebp),%eax
801022a4:	8a 00                	mov    (%eax),%al
801022a6:	84 c0                	test   %al,%al
801022a8:	75 07                	jne    801022b1 <skipelem+0x24>
    return 0;
801022aa:	b8 00 00 00 00       	mov    $0x0,%eax
801022af:	eb 76                	jmp    80102327 <skipelem+0x9a>
  s = path;
801022b1:	8b 45 08             	mov    0x8(%ebp),%eax
801022b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022b7:	eb 03                	jmp    801022bc <skipelem+0x2f>
    path++;
801022b9:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022bc:	8b 45 08             	mov    0x8(%ebp),%eax
801022bf:	8a 00                	mov    (%eax),%al
801022c1:	3c 2f                	cmp    $0x2f,%al
801022c3:	74 09                	je     801022ce <skipelem+0x41>
801022c5:	8b 45 08             	mov    0x8(%ebp),%eax
801022c8:	8a 00                	mov    (%eax),%al
801022ca:	84 c0                	test   %al,%al
801022cc:	75 eb                	jne    801022b9 <skipelem+0x2c>
    path++;
  len = path - s;
801022ce:	8b 55 08             	mov    0x8(%ebp),%edx
801022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022d4:	89 d1                	mov    %edx,%ecx
801022d6:	29 c1                	sub    %eax,%ecx
801022d8:	89 c8                	mov    %ecx,%eax
801022da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022dd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022e1:	7e 15                	jle    801022f8 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801022e3:	83 ec 04             	sub    $0x4,%esp
801022e6:	6a 0e                	push   $0xe
801022e8:	ff 75 f4             	pushl  -0xc(%ebp)
801022eb:	ff 75 0c             	pushl  0xc(%ebp)
801022ee:	e8 a3 2b 00 00       	call   80104e96 <memmove>
801022f3:	83 c4 10             	add    $0x10,%esp
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022f6:	eb 23                	jmp    8010231b <skipelem+0x8e>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022fb:	83 ec 04             	sub    $0x4,%esp
801022fe:	50                   	push   %eax
801022ff:	ff 75 f4             	pushl  -0xc(%ebp)
80102302:	ff 75 0c             	pushl  0xc(%ebp)
80102305:	e8 8c 2b 00 00       	call   80104e96 <memmove>
8010230a:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102310:	03 45 0c             	add    0xc(%ebp),%eax
80102313:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102316:	eb 03                	jmp    8010231b <skipelem+0x8e>
    path++;
80102318:	ff 45 08             	incl   0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010231b:	8b 45 08             	mov    0x8(%ebp),%eax
8010231e:	8a 00                	mov    (%eax),%al
80102320:	3c 2f                	cmp    $0x2f,%al
80102322:	74 f4                	je     80102318 <skipelem+0x8b>
    path++;
  return path;
80102324:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102327:	c9                   	leave  
80102328:	c3                   	ret    

80102329 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102329:	55                   	push   %ebp
8010232a:	89 e5                	mov    %esp,%ebp
8010232c:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
80102332:	8a 00                	mov    (%eax),%al
80102334:	3c 2f                	cmp    $0x2f,%al
80102336:	75 17                	jne    8010234f <namex+0x26>
    ip = iget(ROOTDEV, ROOTINO);
80102338:	83 ec 08             	sub    $0x8,%esp
8010233b:	6a 01                	push   $0x1
8010233d:	6a 01                	push   $0x1
8010233f:	e8 4c f4 ff ff       	call   80101790 <iget>
80102344:	83 c4 10             	add    $0x10,%esp
80102347:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010234a:	e9 b9 00 00 00       	jmp    80102408 <namex+0xdf>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010234f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102355:	8b 40 68             	mov    0x68(%eax),%eax
80102358:	83 ec 0c             	sub    $0xc,%esp
8010235b:	50                   	push   %eax
8010235c:	e8 0f f5 ff ff       	call   80101870 <idup>
80102361:	83 c4 10             	add    $0x10,%esp
80102364:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102367:	e9 9c 00 00 00       	jmp    80102408 <namex+0xdf>
    ilock(ip);
8010236c:	83 ec 0c             	sub    $0xc,%esp
8010236f:	ff 75 f4             	pushl  -0xc(%ebp)
80102372:	e8 33 f5 ff ff       	call   801018aa <ilock>
80102377:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237d:	8b 40 10             	mov    0x10(%eax),%eax
80102380:	66 83 f8 01          	cmp    $0x1,%ax
80102384:	74 18                	je     8010239e <namex+0x75>
      iunlockput(ip);
80102386:	83 ec 0c             	sub    $0xc,%esp
80102389:	ff 75 f4             	pushl  -0xc(%ebp)
8010238c:	e8 d0 f7 ff ff       	call   80101b61 <iunlockput>
80102391:	83 c4 10             	add    $0x10,%esp
      return 0;
80102394:	b8 00 00 00 00       	mov    $0x0,%eax
80102399:	e9 a6 00 00 00       	jmp    80102444 <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
8010239e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023a2:	74 1f                	je     801023c3 <namex+0x9a>
801023a4:	8b 45 08             	mov    0x8(%ebp),%eax
801023a7:	8a 00                	mov    (%eax),%al
801023a9:	84 c0                	test   %al,%al
801023ab:	75 16                	jne    801023c3 <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
801023ad:	83 ec 0c             	sub    $0xc,%esp
801023b0:	ff 75 f4             	pushl  -0xc(%ebp)
801023b3:	e8 49 f6 ff ff       	call   80101a01 <iunlock>
801023b8:	83 c4 10             	add    $0x10,%esp
      return ip;
801023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023be:	e9 81 00 00 00       	jmp    80102444 <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023c3:	83 ec 04             	sub    $0x4,%esp
801023c6:	6a 00                	push   $0x0
801023c8:	ff 75 10             	pushl  0x10(%ebp)
801023cb:	ff 75 f4             	pushl  -0xc(%ebp)
801023ce:	e8 2c fd ff ff       	call   801020ff <dirlookup>
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023dd:	75 15                	jne    801023f4 <namex+0xcb>
      iunlockput(ip);
801023df:	83 ec 0c             	sub    $0xc,%esp
801023e2:	ff 75 f4             	pushl  -0xc(%ebp)
801023e5:	e8 77 f7 ff ff       	call   80101b61 <iunlockput>
801023ea:	83 c4 10             	add    $0x10,%esp
      return 0;
801023ed:	b8 00 00 00 00       	mov    $0x0,%eax
801023f2:	eb 50                	jmp    80102444 <namex+0x11b>
    }
    iunlockput(ip);
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	ff 75 f4             	pushl  -0xc(%ebp)
801023fa:	e8 62 f7 ff ff       	call   80101b61 <iunlockput>
801023ff:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102402:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102405:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	ff 75 10             	pushl  0x10(%ebp)
8010240e:	ff 75 08             	pushl  0x8(%ebp)
80102411:	e8 77 fe ff ff       	call   8010228d <skipelem>
80102416:	83 c4 10             	add    $0x10,%esp
80102419:	89 45 08             	mov    %eax,0x8(%ebp)
8010241c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102420:	0f 85 46 ff ff ff    	jne    8010236c <namex+0x43>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102426:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010242a:	74 15                	je     80102441 <namex+0x118>
    iput(ip);
8010242c:	83 ec 0c             	sub    $0xc,%esp
8010242f:	ff 75 f4             	pushl  -0xc(%ebp)
80102432:	e8 3b f6 ff ff       	call   80101a72 <iput>
80102437:	83 c4 10             	add    $0x10,%esp
    return 0;
8010243a:	b8 00 00 00 00       	mov    $0x0,%eax
8010243f:	eb 03                	jmp    80102444 <namex+0x11b>
  }
  return ip;
80102441:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102444:	c9                   	leave  
80102445:	c3                   	ret    

80102446 <namei>:

struct inode*
namei(char *path)
{
80102446:	55                   	push   %ebp
80102447:	89 e5                	mov    %esp,%ebp
80102449:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010244c:	83 ec 04             	sub    $0x4,%esp
8010244f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102452:	50                   	push   %eax
80102453:	6a 00                	push   $0x0
80102455:	ff 75 08             	pushl  0x8(%ebp)
80102458:	e8 cc fe ff ff       	call   80102329 <namex>
8010245d:	83 c4 10             	add    $0x10,%esp
}
80102460:	c9                   	leave  
80102461:	c3                   	ret    

80102462 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102462:	55                   	push   %ebp
80102463:	89 e5                	mov    %esp,%ebp
80102465:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102468:	83 ec 04             	sub    $0x4,%esp
8010246b:	ff 75 0c             	pushl  0xc(%ebp)
8010246e:	6a 01                	push   $0x1
80102470:	ff 75 08             	pushl  0x8(%ebp)
80102473:	e8 b1 fe ff ff       	call   80102329 <namex>
80102478:	83 c4 10             	add    $0x10,%esp
}
8010247b:	c9                   	leave  
8010247c:	c3                   	ret    
8010247d:	00 00                	add    %al,(%eax)
	...

80102480 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	53                   	push   %ebx
80102484:	83 ec 18             	sub    $0x18,%esp
80102487:	8b 45 08             	mov    0x8(%ebp),%eax
8010248a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010248e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102491:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80102495:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80102499:	ec                   	in     (%dx),%al
8010249a:	88 c3                	mov    %al,%bl
8010249c:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010249f:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801024a2:	83 c4 18             	add    $0x18,%esp
801024a5:	5b                   	pop    %ebx
801024a6:	c9                   	leave  
801024a7:	c3                   	ret    

801024a8 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024a8:	55                   	push   %ebp
801024a9:	89 e5                	mov    %esp,%ebp
801024ab:	57                   	push   %edi
801024ac:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024ad:	8b 55 08             	mov    0x8(%ebp),%edx
801024b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024b3:	8b 45 10             	mov    0x10(%ebp),%eax
801024b6:	89 cb                	mov    %ecx,%ebx
801024b8:	89 df                	mov    %ebx,%edi
801024ba:	89 c1                	mov    %eax,%ecx
801024bc:	fc                   	cld    
801024bd:	f3 6d                	rep insl (%dx),%es:(%edi)
801024bf:	89 c8                	mov    %ecx,%eax
801024c1:	89 fb                	mov    %edi,%ebx
801024c3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024c6:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024c9:	5b                   	pop    %ebx
801024ca:	5f                   	pop    %edi
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    

801024cd <outb>:

static inline void
outb(ushort port, uchar data)
{
801024cd:	55                   	push   %ebp
801024ce:	89 e5                	mov    %esp,%ebp
801024d0:	83 ec 08             	sub    $0x8,%esp
801024d3:	8b 45 08             	mov    0x8(%ebp),%eax
801024d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801024d9:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801024dd:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024e0:	8a 45 f8             	mov    -0x8(%ebp),%al
801024e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
801024e6:	ee                   	out    %al,(%dx)
}
801024e7:	c9                   	leave  
801024e8:	c3                   	ret    

801024e9 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024e9:	55                   	push   %ebp
801024ea:	89 e5                	mov    %esp,%ebp
801024ec:	56                   	push   %esi
801024ed:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024ee:	8b 55 08             	mov    0x8(%ebp),%edx
801024f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024f4:	8b 45 10             	mov    0x10(%ebp),%eax
801024f7:	89 cb                	mov    %ecx,%ebx
801024f9:	89 de                	mov    %ebx,%esi
801024fb:	89 c1                	mov    %eax,%ecx
801024fd:	fc                   	cld    
801024fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102500:	89 c8                	mov    %ecx,%eax
80102502:	89 f3                	mov    %esi,%ebx
80102504:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102507:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
8010250a:	5b                   	pop    %ebx
8010250b:	5e                   	pop    %esi
8010250c:	c9                   	leave  
8010250d:	c3                   	ret    

8010250e <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
8010250e:	55                   	push   %ebp
8010250f:	89 e5                	mov    %esp,%ebp
80102511:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102514:	90                   	nop
80102515:	68 f7 01 00 00       	push   $0x1f7
8010251a:	e8 61 ff ff ff       	call   80102480 <inb>
8010251f:	83 c4 04             	add    $0x4,%esp
80102522:	0f b6 c0             	movzbl %al,%eax
80102525:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102528:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010252b:	25 c0 00 00 00       	and    $0xc0,%eax
80102530:	83 f8 40             	cmp    $0x40,%eax
80102533:	75 e0                	jne    80102515 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102535:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102539:	74 11                	je     8010254c <idewait+0x3e>
8010253b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010253e:	83 e0 21             	and    $0x21,%eax
80102541:	85 c0                	test   %eax,%eax
80102543:	74 07                	je     8010254c <idewait+0x3e>
    return -1;
80102545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010254a:	eb 05                	jmp    80102551 <idewait+0x43>
  return 0;
8010254c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102551:	c9                   	leave  
80102552:	c3                   	ret    

80102553 <ideinit>:

void
ideinit(void)
{
80102553:	55                   	push   %ebp
80102554:	89 e5                	mov    %esp,%ebp
80102556:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102559:	83 ec 08             	sub    $0x8,%esp
8010255c:	68 24 81 10 80       	push   $0x80108124
80102561:	68 00 b6 10 80       	push   $0x8010b600
80102566:	e8 fb 25 00 00       	call   80104b66 <initlock>
8010256b:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
8010256e:	83 ec 0c             	sub    $0xc,%esp
80102571:	6a 0e                	push   $0xe
80102573:	e8 7d 15 00 00       	call   80103af5 <picenable>
80102578:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010257b:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80102580:	48                   	dec    %eax
80102581:	83 ec 08             	sub    $0x8,%esp
80102584:	50                   	push   %eax
80102585:	6a 0e                	push   $0xe
80102587:	e8 30 04 00 00       	call   801029bc <ioapicenable>
8010258c:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010258f:	83 ec 0c             	sub    $0xc,%esp
80102592:	6a 00                	push   $0x0
80102594:	e8 75 ff ff ff       	call   8010250e <idewait>
80102599:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010259c:	83 ec 08             	sub    $0x8,%esp
8010259f:	68 f0 00 00 00       	push   $0xf0
801025a4:	68 f6 01 00 00       	push   $0x1f6
801025a9:	e8 1f ff ff ff       	call   801024cd <outb>
801025ae:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801025b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025b8:	eb 23                	jmp    801025dd <ideinit+0x8a>
    if(inb(0x1f7) != 0){
801025ba:	83 ec 0c             	sub    $0xc,%esp
801025bd:	68 f7 01 00 00       	push   $0x1f7
801025c2:	e8 b9 fe ff ff       	call   80102480 <inb>
801025c7:	83 c4 10             	add    $0x10,%esp
801025ca:	84 c0                	test   %al,%al
801025cc:	74 0c                	je     801025da <ideinit+0x87>
      havedisk1 = 1;
801025ce:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025d5:	00 00 00 
      break;
801025d8:	eb 0c                	jmp    801025e6 <ideinit+0x93>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025da:	ff 45 f4             	incl   -0xc(%ebp)
801025dd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025e4:	7e d4                	jle    801025ba <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025e6:	83 ec 08             	sub    $0x8,%esp
801025e9:	68 e0 00 00 00       	push   $0xe0
801025ee:	68 f6 01 00 00       	push   $0x1f6
801025f3:	e8 d5 fe ff ff       	call   801024cd <outb>
801025f8:	83 c4 10             	add    $0x10,%esp
}
801025fb:	c9                   	leave  
801025fc:	c3                   	ret    

801025fd <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025fd:	55                   	push   %ebp
801025fe:	89 e5                	mov    %esp,%ebp
80102600:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102607:	75 0d                	jne    80102616 <idestart+0x19>
    panic("idestart");
80102609:	83 ec 0c             	sub    $0xc,%esp
8010260c:	68 28 81 10 80       	push   $0x80108128
80102611:	e8 49 df ff ff       	call   8010055f <panic>

  idewait(0);
80102616:	83 ec 0c             	sub    $0xc,%esp
80102619:	6a 00                	push   $0x0
8010261b:	e8 ee fe ff ff       	call   8010250e <idewait>
80102620:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102623:	83 ec 08             	sub    $0x8,%esp
80102626:	6a 00                	push   $0x0
80102628:	68 f6 03 00 00       	push   $0x3f6
8010262d:	e8 9b fe ff ff       	call   801024cd <outb>
80102632:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
80102635:	83 ec 08             	sub    $0x8,%esp
80102638:	6a 01                	push   $0x1
8010263a:	68 f2 01 00 00       	push   $0x1f2
8010263f:	e8 89 fe ff ff       	call   801024cd <outb>
80102644:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
80102647:	8b 45 08             	mov    0x8(%ebp),%eax
8010264a:	8b 40 08             	mov    0x8(%eax),%eax
8010264d:	0f b6 c0             	movzbl %al,%eax
80102650:	83 ec 08             	sub    $0x8,%esp
80102653:	50                   	push   %eax
80102654:	68 f3 01 00 00       	push   $0x1f3
80102659:	e8 6f fe ff ff       	call   801024cd <outb>
8010265e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102661:	8b 45 08             	mov    0x8(%ebp),%eax
80102664:	8b 40 08             	mov    0x8(%eax),%eax
80102667:	c1 e8 08             	shr    $0x8,%eax
8010266a:	0f b6 c0             	movzbl %al,%eax
8010266d:	83 ec 08             	sub    $0x8,%esp
80102670:	50                   	push   %eax
80102671:	68 f4 01 00 00       	push   $0x1f4
80102676:	e8 52 fe ff ff       	call   801024cd <outb>
8010267b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010267e:	8b 45 08             	mov    0x8(%ebp),%eax
80102681:	8b 40 08             	mov    0x8(%eax),%eax
80102684:	c1 e8 10             	shr    $0x10,%eax
80102687:	0f b6 c0             	movzbl %al,%eax
8010268a:	83 ec 08             	sub    $0x8,%esp
8010268d:	50                   	push   %eax
8010268e:	68 f5 01 00 00       	push   $0x1f5
80102693:	e8 35 fe ff ff       	call   801024cd <outb>
80102698:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	8b 40 04             	mov    0x4(%eax),%eax
801026a1:	83 e0 01             	and    $0x1,%eax
801026a4:	88 c2                	mov    %al,%dl
801026a6:	c1 e2 04             	shl    $0x4,%edx
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
801026ac:	8b 40 08             	mov    0x8(%eax),%eax
801026af:	c1 e8 18             	shr    $0x18,%eax
801026b2:	83 e0 0f             	and    $0xf,%eax
801026b5:	09 d0                	or     %edx,%eax
801026b7:	83 c8 e0             	or     $0xffffffe0,%eax
801026ba:	0f b6 c0             	movzbl %al,%eax
801026bd:	83 ec 08             	sub    $0x8,%esp
801026c0:	50                   	push   %eax
801026c1:	68 f6 01 00 00       	push   $0x1f6
801026c6:	e8 02 fe ff ff       	call   801024cd <outb>
801026cb:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801026ce:	8b 45 08             	mov    0x8(%ebp),%eax
801026d1:	8b 00                	mov    (%eax),%eax
801026d3:	83 e0 04             	and    $0x4,%eax
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 30                	je     8010270a <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
801026da:	83 ec 08             	sub    $0x8,%esp
801026dd:	6a 30                	push   $0x30
801026df:	68 f7 01 00 00       	push   $0x1f7
801026e4:	e8 e4 fd ff ff       	call   801024cd <outb>
801026e9:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
801026ec:	8b 45 08             	mov    0x8(%ebp),%eax
801026ef:	83 c0 18             	add    $0x18,%eax
801026f2:	83 ec 04             	sub    $0x4,%esp
801026f5:	68 80 00 00 00       	push   $0x80
801026fa:	50                   	push   %eax
801026fb:	68 f0 01 00 00       	push   $0x1f0
80102700:	e8 e4 fd ff ff       	call   801024e9 <outsl>
80102705:	83 c4 10             	add    $0x10,%esp
80102708:	eb 12                	jmp    8010271c <idestart+0x11f>
  } else {
    outb(0x1f7, IDE_CMD_READ);
8010270a:	83 ec 08             	sub    $0x8,%esp
8010270d:	6a 20                	push   $0x20
8010270f:	68 f7 01 00 00       	push   $0x1f7
80102714:	e8 b4 fd ff ff       	call   801024cd <outb>
80102719:	83 c4 10             	add    $0x10,%esp
  }
}
8010271c:	c9                   	leave  
8010271d:	c3                   	ret    

8010271e <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010271e:	55                   	push   %ebp
8010271f:	89 e5                	mov    %esp,%ebp
80102721:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102724:	83 ec 0c             	sub    $0xc,%esp
80102727:	68 00 b6 10 80       	push   $0x8010b600
8010272c:	e8 56 24 00 00       	call   80104b87 <acquire>
80102731:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102734:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102739:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102740:	75 15                	jne    80102757 <ideintr+0x39>
    release(&idelock);
80102742:	83 ec 0c             	sub    $0xc,%esp
80102745:	68 00 b6 10 80       	push   $0x8010b600
8010274a:	e8 9e 24 00 00       	call   80104bed <release>
8010274f:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102752:	e9 9a 00 00 00       	jmp    801027f1 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010275a:	8b 40 14             	mov    0x14(%eax),%eax
8010275d:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102765:	8b 00                	mov    (%eax),%eax
80102767:	83 e0 04             	and    $0x4,%eax
8010276a:	85 c0                	test   %eax,%eax
8010276c:	75 2d                	jne    8010279b <ideintr+0x7d>
8010276e:	83 ec 0c             	sub    $0xc,%esp
80102771:	6a 01                	push   $0x1
80102773:	e8 96 fd ff ff       	call   8010250e <idewait>
80102778:	83 c4 10             	add    $0x10,%esp
8010277b:	85 c0                	test   %eax,%eax
8010277d:	78 1c                	js     8010279b <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
8010277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102782:	83 c0 18             	add    $0x18,%eax
80102785:	83 ec 04             	sub    $0x4,%esp
80102788:	68 80 00 00 00       	push   $0x80
8010278d:	50                   	push   %eax
8010278e:	68 f0 01 00 00       	push   $0x1f0
80102793:	e8 10 fd ff ff       	call   801024a8 <insl>
80102798:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279e:	8b 00                	mov    (%eax),%eax
801027a0:	89 c2                	mov    %eax,%edx
801027a2:	83 ca 02             	or     $0x2,%edx
801027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a8:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ad:	8b 00                	mov    (%eax),%eax
801027af:	89 c2                	mov    %eax,%edx
801027b1:	83 e2 fb             	and    $0xfffffffb,%edx
801027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027b7:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027b9:	83 ec 0c             	sub    $0xc,%esp
801027bc:	ff 75 f4             	pushl  -0xc(%ebp)
801027bf:	e8 aa 21 00 00       	call   8010496e <wakeup>
801027c4:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c7:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027cc:	85 c0                	test   %eax,%eax
801027ce:	74 11                	je     801027e1 <ideintr+0xc3>
    idestart(idequeue);
801027d0:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801027d5:	83 ec 0c             	sub    $0xc,%esp
801027d8:	50                   	push   %eax
801027d9:	e8 1f fe ff ff       	call   801025fd <idestart>
801027de:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801027e1:	83 ec 0c             	sub    $0xc,%esp
801027e4:	68 00 b6 10 80       	push   $0x8010b600
801027e9:	e8 ff 23 00 00       	call   80104bed <release>
801027ee:	83 c4 10             	add    $0x10,%esp
}
801027f1:	c9                   	leave  
801027f2:	c3                   	ret    

801027f3 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027f3:	55                   	push   %ebp
801027f4:	89 e5                	mov    %esp,%ebp
801027f6:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027f9:	8b 45 08             	mov    0x8(%ebp),%eax
801027fc:	8b 00                	mov    (%eax),%eax
801027fe:	83 e0 01             	and    $0x1,%eax
80102801:	85 c0                	test   %eax,%eax
80102803:	75 0d                	jne    80102812 <iderw+0x1f>
    panic("iderw: buf not busy");
80102805:	83 ec 0c             	sub    $0xc,%esp
80102808:	68 31 81 10 80       	push   $0x80108131
8010280d:	e8 4d dd ff ff       	call   8010055f <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102812:	8b 45 08             	mov    0x8(%ebp),%eax
80102815:	8b 00                	mov    (%eax),%eax
80102817:	83 e0 06             	and    $0x6,%eax
8010281a:	83 f8 02             	cmp    $0x2,%eax
8010281d:	75 0d                	jne    8010282c <iderw+0x39>
    panic("iderw: nothing to do");
8010281f:	83 ec 0c             	sub    $0xc,%esp
80102822:	68 45 81 10 80       	push   $0x80108145
80102827:	e8 33 dd ff ff       	call   8010055f <panic>
  if(b->dev != 0 && !havedisk1)
8010282c:	8b 45 08             	mov    0x8(%ebp),%eax
8010282f:	8b 40 04             	mov    0x4(%eax),%eax
80102832:	85 c0                	test   %eax,%eax
80102834:	74 16                	je     8010284c <iderw+0x59>
80102836:	a1 38 b6 10 80       	mov    0x8010b638,%eax
8010283b:	85 c0                	test   %eax,%eax
8010283d:	75 0d                	jne    8010284c <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010283f:	83 ec 0c             	sub    $0xc,%esp
80102842:	68 5a 81 10 80       	push   $0x8010815a
80102847:	e8 13 dd ff ff       	call   8010055f <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010284c:	83 ec 0c             	sub    $0xc,%esp
8010284f:	68 00 b6 10 80       	push   $0x8010b600
80102854:	e8 2e 23 00 00       	call   80104b87 <acquire>
80102859:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010285c:	8b 45 08             	mov    0x8(%ebp),%eax
8010285f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102866:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
8010286d:	eb 0b                	jmp    8010287a <iderw+0x87>
8010286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102872:	8b 00                	mov    (%eax),%eax
80102874:	83 c0 14             	add    $0x14,%eax
80102877:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287d:	8b 00                	mov    (%eax),%eax
8010287f:	85 c0                	test   %eax,%eax
80102881:	75 ec                	jne    8010286f <iderw+0x7c>
    ;
  *pp = b;
80102883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102886:	8b 55 08             	mov    0x8(%ebp),%edx
80102889:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010288b:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102890:	3b 45 08             	cmp    0x8(%ebp),%eax
80102893:	75 25                	jne    801028ba <iderw+0xc7>
    idestart(b);
80102895:	83 ec 0c             	sub    $0xc,%esp
80102898:	ff 75 08             	pushl  0x8(%ebp)
8010289b:	e8 5d fd ff ff       	call   801025fd <idestart>
801028a0:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028a3:	eb 16                	jmp    801028bb <iderw+0xc8>
    sleep(b, &idelock);
801028a5:	83 ec 08             	sub    $0x8,%esp
801028a8:	68 00 b6 10 80       	push   $0x8010b600
801028ad:	ff 75 08             	pushl  0x8(%ebp)
801028b0:	e8 cf 1f 00 00       	call   80104884 <sleep>
801028b5:	83 c4 10             	add    $0x10,%esp
801028b8:	eb 01                	jmp    801028bb <iderw+0xc8>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ba:	90                   	nop
801028bb:	8b 45 08             	mov    0x8(%ebp),%eax
801028be:	8b 00                	mov    (%eax),%eax
801028c0:	83 e0 06             	and    $0x6,%eax
801028c3:	83 f8 02             	cmp    $0x2,%eax
801028c6:	75 dd                	jne    801028a5 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
801028c8:	83 ec 0c             	sub    $0xc,%esp
801028cb:	68 00 b6 10 80       	push   $0x8010b600
801028d0:	e8 18 23 00 00       	call   80104bed <release>
801028d5:	83 c4 10             	add    $0x10,%esp
}
801028d8:	c9                   	leave  
801028d9:	c3                   	ret    
	...

801028dc <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028dc:	55                   	push   %ebp
801028dd:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028df:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028e4:	8b 55 08             	mov    0x8(%ebp),%edx
801028e7:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028e9:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028ee:	8b 40 10             	mov    0x10(%eax),%eax
}
801028f1:	c9                   	leave  
801028f2:	c3                   	ret    

801028f3 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028f3:	55                   	push   %ebp
801028f4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028f6:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028fb:	8b 55 08             	mov    0x8(%ebp),%edx
801028fe:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102900:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102905:	8b 55 0c             	mov    0xc(%ebp),%edx
80102908:	89 50 10             	mov    %edx,0x10(%eax)
}
8010290b:	c9                   	leave  
8010290c:	c3                   	ret    

8010290d <ioapicinit>:

void
ioapicinit(void)
{
8010290d:	55                   	push   %ebp
8010290e:	89 e5                	mov    %esp,%ebp
80102910:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102913:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102918:	85 c0                	test   %eax,%eax
8010291a:	0f 84 99 00 00 00    	je     801029b9 <ioapicinit+0xac>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102920:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
80102927:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010292a:	6a 01                	push   $0x1
8010292c:	e8 ab ff ff ff       	call   801028dc <ioapicread>
80102931:	83 c4 04             	add    $0x4,%esp
80102934:	c1 e8 10             	shr    $0x10,%eax
80102937:	25 ff 00 00 00       	and    $0xff,%eax
8010293c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
8010293f:	6a 00                	push   $0x0
80102941:	e8 96 ff ff ff       	call   801028dc <ioapicread>
80102946:	83 c4 04             	add    $0x4,%esp
80102949:	c1 e8 18             	shr    $0x18,%eax
8010294c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
8010294f:	a0 00 f9 10 80       	mov    0x8010f900,%al
80102954:	0f b6 c0             	movzbl %al,%eax
80102957:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010295a:	74 10                	je     8010296c <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010295c:	83 ec 0c             	sub    $0xc,%esp
8010295f:	68 78 81 10 80       	push   $0x80108178
80102964:	e8 57 da ff ff       	call   801003c0 <cprintf>
80102969:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010296c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102973:	eb 3a                	jmp    801029af <ioapicinit+0xa2>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102978:	83 c0 20             	add    $0x20,%eax
8010297b:	0d 00 00 01 00       	or     $0x10000,%eax
80102980:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102983:	83 c2 08             	add    $0x8,%edx
80102986:	d1 e2                	shl    %edx
80102988:	83 ec 08             	sub    $0x8,%esp
8010298b:	50                   	push   %eax
8010298c:	52                   	push   %edx
8010298d:	e8 61 ff ff ff       	call   801028f3 <ioapicwrite>
80102992:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102998:	83 c0 08             	add    $0x8,%eax
8010299b:	d1 e0                	shl    %eax
8010299d:	40                   	inc    %eax
8010299e:	83 ec 08             	sub    $0x8,%esp
801029a1:	6a 00                	push   $0x0
801029a3:	50                   	push   %eax
801029a4:	e8 4a ff ff ff       	call   801028f3 <ioapicwrite>
801029a9:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ac:	ff 45 f4             	incl   -0xc(%ebp)
801029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801029b5:	7e be                	jle    80102975 <ioapicinit+0x68>
801029b7:	eb 01                	jmp    801029ba <ioapicinit+0xad>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
801029b9:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029ba:	c9                   	leave  
801029bb:	c3                   	ret    

801029bc <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029bc:	55                   	push   %ebp
801029bd:	89 e5                	mov    %esp,%ebp
  if(!ismp)
801029bf:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801029c4:	85 c0                	test   %eax,%eax
801029c6:	74 33                	je     801029fb <ioapicenable+0x3f>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029c8:	8b 45 08             	mov    0x8(%ebp),%eax
801029cb:	83 c0 20             	add    $0x20,%eax
801029ce:	8b 55 08             	mov    0x8(%ebp),%edx
801029d1:	83 c2 08             	add    $0x8,%edx
801029d4:	d1 e2                	shl    %edx
801029d6:	50                   	push   %eax
801029d7:	52                   	push   %edx
801029d8:	e8 16 ff ff ff       	call   801028f3 <ioapicwrite>
801029dd:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e3:	c1 e0 18             	shl    $0x18,%eax
801029e6:	8b 55 08             	mov    0x8(%ebp),%edx
801029e9:	83 c2 08             	add    $0x8,%edx
801029ec:	d1 e2                	shl    %edx
801029ee:	42                   	inc    %edx
801029ef:	50                   	push   %eax
801029f0:	52                   	push   %edx
801029f1:	e8 fd fe ff ff       	call   801028f3 <ioapicwrite>
801029f6:	83 c4 08             	add    $0x8,%esp
801029f9:	eb 01                	jmp    801029fc <ioapicenable+0x40>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029fb:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029fc:	c9                   	leave  
801029fd:	c3                   	ret    
	...

80102a00 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	8b 45 08             	mov    0x8(%ebp),%eax
80102a06:	2d 00 00 00 80       	sub    $0x80000000,%eax
80102a0b:	c9                   	leave  
80102a0c:	c3                   	ret    

80102a0d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a0d:	55                   	push   %ebp
80102a0e:	89 e5                	mov    %esp,%ebp
80102a10:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102a13:	83 ec 08             	sub    $0x8,%esp
80102a16:	68 aa 81 10 80       	push   $0x801081aa
80102a1b:	68 40 f8 10 80       	push   $0x8010f840
80102a20:	e8 41 21 00 00       	call   80104b66 <initlock>
80102a25:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a28:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
80102a2f:	00 00 00 
  freerange(vstart, vend);
80102a32:	83 ec 08             	sub    $0x8,%esp
80102a35:	ff 75 0c             	pushl  0xc(%ebp)
80102a38:	ff 75 08             	pushl  0x8(%ebp)
80102a3b:	e8 28 00 00 00       	call   80102a68 <freerange>
80102a40:	83 c4 10             	add    $0x10,%esp
}
80102a43:	c9                   	leave  
80102a44:	c3                   	ret    

80102a45 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a45:	55                   	push   %ebp
80102a46:	89 e5                	mov    %esp,%ebp
80102a48:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102a4b:	83 ec 08             	sub    $0x8,%esp
80102a4e:	ff 75 0c             	pushl  0xc(%ebp)
80102a51:	ff 75 08             	pushl  0x8(%ebp)
80102a54:	e8 0f 00 00 00       	call   80102a68 <freerange>
80102a59:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102a5c:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a63:	00 00 00 
}
80102a66:	c9                   	leave  
80102a67:	c3                   	ret    

80102a68 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a68:	55                   	push   %ebp
80102a69:	89 e5                	mov    %esp,%ebp
80102a6b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a7e:	eb 15                	jmp    80102a95 <freerange+0x2d>
    kfree(p);
80102a80:	83 ec 0c             	sub    $0xc,%esp
80102a83:	ff 75 f4             	pushl  -0xc(%ebp)
80102a86:	e8 1c 00 00 00       	call   80102aa7 <kfree>
80102a8b:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a98:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
80102a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102aa1:	39 c2                	cmp    %eax,%edx
80102aa3:	76 db                	jbe    80102a80 <freerange+0x18>
    kfree(p);
}
80102aa5:	c9                   	leave  
80102aa6:	c3                   	ret    

80102aa7 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102aa7:	55                   	push   %ebp
80102aa8:	89 e5                	mov    %esp,%ebp
80102aaa:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102aad:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab0:	25 ff 0f 00 00       	and    $0xfff,%eax
80102ab5:	85 c0                	test   %eax,%eax
80102ab7:	75 1b                	jne    80102ad4 <kfree+0x2d>
80102ab9:	81 7d 08 fc 26 11 80 	cmpl   $0x801126fc,0x8(%ebp)
80102ac0:	72 12                	jb     80102ad4 <kfree+0x2d>
80102ac2:	ff 75 08             	pushl  0x8(%ebp)
80102ac5:	e8 36 ff ff ff       	call   80102a00 <v2p>
80102aca:	83 c4 04             	add    $0x4,%esp
80102acd:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ad2:	76 0d                	jbe    80102ae1 <kfree+0x3a>
    panic("kfree");
80102ad4:	83 ec 0c             	sub    $0xc,%esp
80102ad7:	68 af 81 10 80       	push   $0x801081af
80102adc:	e8 7e da ff ff       	call   8010055f <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ae1:	83 ec 04             	sub    $0x4,%esp
80102ae4:	68 00 10 00 00       	push   $0x1000
80102ae9:	6a 01                	push   $0x1
80102aeb:	ff 75 08             	pushl  0x8(%ebp)
80102aee:	e8 e7 22 00 00       	call   80104dda <memset>
80102af3:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102af6:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102afb:	85 c0                	test   %eax,%eax
80102afd:	74 10                	je     80102b0f <kfree+0x68>
    acquire(&kmem.lock);
80102aff:	83 ec 0c             	sub    $0xc,%esp
80102b02:	68 40 f8 10 80       	push   $0x8010f840
80102b07:	e8 7b 20 00 00       	call   80104b87 <acquire>
80102b0c:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b15:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b1e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b23:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b28:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b2d:	85 c0                	test   %eax,%eax
80102b2f:	74 10                	je     80102b41 <kfree+0x9a>
    release(&kmem.lock);
80102b31:	83 ec 0c             	sub    $0xc,%esp
80102b34:	68 40 f8 10 80       	push   $0x8010f840
80102b39:	e8 af 20 00 00       	call   80104bed <release>
80102b3e:	83 c4 10             	add    $0x10,%esp
}
80102b41:	c9                   	leave  
80102b42:	c3                   	ret    

80102b43 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b43:	55                   	push   %ebp
80102b44:	89 e5                	mov    %esp,%ebp
80102b46:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102b49:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b4e:	85 c0                	test   %eax,%eax
80102b50:	74 10                	je     80102b62 <kalloc+0x1f>
    acquire(&kmem.lock);
80102b52:	83 ec 0c             	sub    $0xc,%esp
80102b55:	68 40 f8 10 80       	push   $0x8010f840
80102b5a:	e8 28 20 00 00       	call   80104b87 <acquire>
80102b5f:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102b62:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b6e:	74 0a                	je     80102b7a <kalloc+0x37>
    kmem.freelist = r->next;
80102b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b73:	8b 00                	mov    (%eax),%eax
80102b75:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b7a:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b7f:	85 c0                	test   %eax,%eax
80102b81:	74 10                	je     80102b93 <kalloc+0x50>
    release(&kmem.lock);
80102b83:	83 ec 0c             	sub    $0xc,%esp
80102b86:	68 40 f8 10 80       	push   $0x8010f840
80102b8b:	e8 5d 20 00 00       	call   80104bed <release>
80102b90:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b96:	c9                   	leave  
80102b97:	c3                   	ret    

80102b98 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b98:	55                   	push   %ebp
80102b99:	89 e5                	mov    %esp,%ebp
80102b9b:	53                   	push   %ebx
80102b9c:	83 ec 18             	sub    $0x18,%esp
80102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba2:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ba6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102ba9:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80102bad:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80102bb1:	ec                   	in     (%dx),%al
80102bb2:	88 c3                	mov    %al,%bl
80102bb4:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102bb7:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102bba:	83 c4 18             	add    $0x18,%esp
80102bbd:	5b                   	pop    %ebx
80102bbe:	c9                   	leave  
80102bbf:	c3                   	ret    

80102bc0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bc6:	6a 64                	push   $0x64
80102bc8:	e8 cb ff ff ff       	call   80102b98 <inb>
80102bcd:	83 c4 04             	add    $0x4,%esp
80102bd0:	0f b6 c0             	movzbl %al,%eax
80102bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd9:	83 e0 01             	and    $0x1,%eax
80102bdc:	85 c0                	test   %eax,%eax
80102bde:	75 0a                	jne    80102bea <kbdgetc+0x2a>
    return -1;
80102be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102be5:	e9 1d 01 00 00       	jmp    80102d07 <kbdgetc+0x147>
  data = inb(KBDATAP);
80102bea:	6a 60                	push   $0x60
80102bec:	e8 a7 ff ff ff       	call   80102b98 <inb>
80102bf1:	83 c4 04             	add    $0x4,%esp
80102bf4:	0f b6 c0             	movzbl %al,%eax
80102bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bfa:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c01:	75 17                	jne    80102c1a <kbdgetc+0x5a>
    shift |= E0ESC;
80102c03:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c08:	83 c8 40             	or     $0x40,%eax
80102c0b:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c10:	b8 00 00 00 00       	mov    $0x0,%eax
80102c15:	e9 ed 00 00 00       	jmp    80102d07 <kbdgetc+0x147>
  } else if(data & 0x80){
80102c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c1d:	25 80 00 00 00       	and    $0x80,%eax
80102c22:	85 c0                	test   %eax,%eax
80102c24:	74 44                	je     80102c6a <kbdgetc+0xaa>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c26:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c2b:	83 e0 40             	and    $0x40,%eax
80102c2e:	85 c0                	test   %eax,%eax
80102c30:	75 08                	jne    80102c3a <kbdgetc+0x7a>
80102c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c35:	83 e0 7f             	and    $0x7f,%eax
80102c38:	eb 03                	jmp    80102c3d <kbdgetc+0x7d>
80102c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c43:	05 20 90 10 80       	add    $0x80109020,%eax
80102c48:	8a 00                	mov    (%eax),%al
80102c4a:	83 c8 40             	or     $0x40,%eax
80102c4d:	0f b6 c0             	movzbl %al,%eax
80102c50:	f7 d0                	not    %eax
80102c52:	89 c2                	mov    %eax,%edx
80102c54:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c59:	21 d0                	and    %edx,%eax
80102c5b:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c60:	b8 00 00 00 00       	mov    $0x0,%eax
80102c65:	e9 9d 00 00 00       	jmp    80102d07 <kbdgetc+0x147>
  } else if(shift & E0ESC){
80102c6a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c6f:	83 e0 40             	and    $0x40,%eax
80102c72:	85 c0                	test   %eax,%eax
80102c74:	74 14                	je     80102c8a <kbdgetc+0xca>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c76:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c7d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c82:	83 e0 bf             	and    $0xffffffbf,%eax
80102c85:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c8d:	05 20 90 10 80       	add    $0x80109020,%eax
80102c92:	8a 00                	mov    (%eax),%al
80102c94:	0f b6 d0             	movzbl %al,%edx
80102c97:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c9c:	09 d0                	or     %edx,%eax
80102c9e:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ca6:	05 20 91 10 80       	add    $0x80109120,%eax
80102cab:	8a 00                	mov    (%eax),%al
80102cad:	0f b6 d0             	movzbl %al,%edx
80102cb0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cb5:	31 d0                	xor    %edx,%eax
80102cb7:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102cbc:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cc1:	83 e0 03             	and    $0x3,%eax
80102cc4:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102ccb:	03 45 fc             	add    -0x4(%ebp),%eax
80102cce:	8a 00                	mov    (%eax),%al
80102cd0:	0f b6 c0             	movzbl %al,%eax
80102cd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102cd6:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102cdb:	83 e0 08             	and    $0x8,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	74 22                	je     80102d04 <kbdgetc+0x144>
    if('a' <= c && c <= 'z')
80102ce2:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ce6:	76 0c                	jbe    80102cf4 <kbdgetc+0x134>
80102ce8:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102cec:	77 06                	ja     80102cf4 <kbdgetc+0x134>
      c += 'A' - 'a';
80102cee:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cf2:	eb 10                	jmp    80102d04 <kbdgetc+0x144>
    else if('A' <= c && c <= 'Z')
80102cf4:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cf8:	76 0a                	jbe    80102d04 <kbdgetc+0x144>
80102cfa:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cfe:	77 04                	ja     80102d04 <kbdgetc+0x144>
      c += 'a' - 'A';
80102d00:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d07:	c9                   	leave  
80102d08:	c3                   	ret    

80102d09 <kbdintr>:

void
kbdintr(void)
{
80102d09:	55                   	push   %ebp
80102d0a:	89 e5                	mov    %esp,%ebp
80102d0c:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102d0f:	83 ec 0c             	sub    $0xc,%esp
80102d12:	68 c0 2b 10 80       	push   $0x80102bc0
80102d17:	e8 a1 da ff ff       	call   801007bd <consoleintr>
80102d1c:	83 c4 10             	add    $0x10,%esp
}
80102d1f:	c9                   	leave  
80102d20:	c3                   	ret    
80102d21:	00 00                	add    %al,(%eax)
	...

80102d24 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d24:	55                   	push   %ebp
80102d25:	89 e5                	mov    %esp,%ebp
80102d27:	83 ec 08             	sub    $0x8,%esp
80102d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d30:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102d34:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d37:	8a 45 f8             	mov    -0x8(%ebp),%al
80102d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102d3d:	ee                   	out    %al,(%dx)
}
80102d3e:	c9                   	leave  
80102d3f:	c3                   	ret    

80102d40 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d47:	9c                   	pushf  
80102d48:	5b                   	pop    %ebx
80102d49:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d4f:	83 c4 10             	add    $0x10,%esp
80102d52:	5b                   	pop    %ebx
80102d53:	c9                   	leave  
80102d54:	c3                   	ret    

80102d55 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d55:	55                   	push   %ebp
80102d56:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d58:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d5d:	8b 55 08             	mov    0x8(%ebp),%edx
80102d60:	c1 e2 02             	shl    $0x2,%edx
80102d63:	8d 14 10             	lea    (%eax,%edx,1),%edx
80102d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d69:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d6b:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d70:	83 c0 20             	add    $0x20,%eax
80102d73:	8b 00                	mov    (%eax),%eax
}
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    

80102d77 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d77:	55                   	push   %ebp
80102d78:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102d7a:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d7f:	85 c0                	test   %eax,%eax
80102d81:	0f 84 0d 01 00 00    	je     80102e94 <lapicinit+0x11d>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d87:	68 3f 01 00 00       	push   $0x13f
80102d8c:	6a 3c                	push   $0x3c
80102d8e:	e8 c2 ff ff ff       	call   80102d55 <lapicw>
80102d93:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d96:	6a 0b                	push   $0xb
80102d98:	68 f8 00 00 00       	push   $0xf8
80102d9d:	e8 b3 ff ff ff       	call   80102d55 <lapicw>
80102da2:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102da5:	68 20 00 02 00       	push   $0x20020
80102daa:	68 c8 00 00 00       	push   $0xc8
80102daf:	e8 a1 ff ff ff       	call   80102d55 <lapicw>
80102db4:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102db7:	68 80 96 98 00       	push   $0x989680
80102dbc:	68 e0 00 00 00       	push   $0xe0
80102dc1:	e8 8f ff ff ff       	call   80102d55 <lapicw>
80102dc6:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102dc9:	68 00 00 01 00       	push   $0x10000
80102dce:	68 d4 00 00 00       	push   $0xd4
80102dd3:	e8 7d ff ff ff       	call   80102d55 <lapicw>
80102dd8:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ddb:	68 00 00 01 00       	push   $0x10000
80102de0:	68 d8 00 00 00       	push   $0xd8
80102de5:	e8 6b ff ff ff       	call   80102d55 <lapicw>
80102dea:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ded:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102df2:	83 c0 30             	add    $0x30,%eax
80102df5:	8b 00                	mov    (%eax),%eax
80102df7:	c1 e8 10             	shr    $0x10,%eax
80102dfa:	25 ff 00 00 00       	and    $0xff,%eax
80102dff:	83 f8 03             	cmp    $0x3,%eax
80102e02:	76 12                	jbe    80102e16 <lapicinit+0x9f>
    lapicw(PCINT, MASKED);
80102e04:	68 00 00 01 00       	push   $0x10000
80102e09:	68 d0 00 00 00       	push   $0xd0
80102e0e:	e8 42 ff ff ff       	call   80102d55 <lapicw>
80102e13:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e16:	6a 33                	push   $0x33
80102e18:	68 dc 00 00 00       	push   $0xdc
80102e1d:	e8 33 ff ff ff       	call   80102d55 <lapicw>
80102e22:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e25:	6a 00                	push   $0x0
80102e27:	68 a0 00 00 00       	push   $0xa0
80102e2c:	e8 24 ff ff ff       	call   80102d55 <lapicw>
80102e31:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102e34:	6a 00                	push   $0x0
80102e36:	68 a0 00 00 00       	push   $0xa0
80102e3b:	e8 15 ff ff ff       	call   80102d55 <lapicw>
80102e40:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e43:	6a 00                	push   $0x0
80102e45:	6a 2c                	push   $0x2c
80102e47:	e8 09 ff ff ff       	call   80102d55 <lapicw>
80102e4c:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e4f:	6a 00                	push   $0x0
80102e51:	68 c4 00 00 00       	push   $0xc4
80102e56:	e8 fa fe ff ff       	call   80102d55 <lapicw>
80102e5b:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e5e:	68 00 85 08 00       	push   $0x88500
80102e63:	68 c0 00 00 00       	push   $0xc0
80102e68:	e8 e8 fe ff ff       	call   80102d55 <lapicw>
80102e6d:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102e70:	90                   	nop
80102e71:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e76:	05 00 03 00 00       	add    $0x300,%eax
80102e7b:	8b 00                	mov    (%eax),%eax
80102e7d:	25 00 10 00 00       	and    $0x1000,%eax
80102e82:	85 c0                	test   %eax,%eax
80102e84:	75 eb                	jne    80102e71 <lapicinit+0xfa>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e86:	6a 00                	push   $0x0
80102e88:	6a 20                	push   $0x20
80102e8a:	e8 c6 fe ff ff       	call   80102d55 <lapicw>
80102e8f:	83 c4 08             	add    $0x8,%esp
80102e92:	eb 01                	jmp    80102e95 <lapicinit+0x11e>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80102e94:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e95:	c9                   	leave  
80102e96:	c3                   	ret    

80102e97 <cpunum>:

int
cpunum(void)
{
80102e97:	55                   	push   %ebp
80102e98:	89 e5                	mov    %esp,%ebp
80102e9a:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e9d:	e8 9e fe ff ff       	call   80102d40 <readeflags>
80102ea2:	25 00 02 00 00       	and    $0x200,%eax
80102ea7:	85 c0                	test   %eax,%eax
80102ea9:	74 28                	je     80102ed3 <cpunum+0x3c>
    static int n;
    if(n++ == 0)
80102eab:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102eb0:	85 c0                	test   %eax,%eax
80102eb2:	0f 94 c2             	sete   %dl
80102eb5:	40                   	inc    %eax
80102eb6:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102ebb:	84 d2                	test   %dl,%dl
80102ebd:	74 14                	je     80102ed3 <cpunum+0x3c>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ebf:	8b 45 04             	mov    0x4(%ebp),%eax
80102ec2:	83 ec 08             	sub    $0x8,%esp
80102ec5:	50                   	push   %eax
80102ec6:	68 b8 81 10 80       	push   $0x801081b8
80102ecb:	e8 f0 d4 ff ff       	call   801003c0 <cprintf>
80102ed0:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102ed3:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ed8:	85 c0                	test   %eax,%eax
80102eda:	74 0f                	je     80102eeb <cpunum+0x54>
    return lapic[ID]>>24;
80102edc:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ee1:	83 c0 20             	add    $0x20,%eax
80102ee4:	8b 00                	mov    (%eax),%eax
80102ee6:	c1 e8 18             	shr    $0x18,%eax
80102ee9:	eb 05                	jmp    80102ef0 <cpunum+0x59>
  return 0;
80102eeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ef0:	c9                   	leave  
80102ef1:	c3                   	ret    

80102ef2 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ef2:	55                   	push   %ebp
80102ef3:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ef5:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102efa:	85 c0                	test   %eax,%eax
80102efc:	74 0c                	je     80102f0a <lapiceoi+0x18>
    lapicw(EOI, 0);
80102efe:	6a 00                	push   $0x0
80102f00:	6a 2c                	push   $0x2c
80102f02:	e8 4e fe ff ff       	call   80102d55 <lapicw>
80102f07:	83 c4 08             	add    $0x8,%esp
}
80102f0a:	c9                   	leave  
80102f0b:	c3                   	ret    

80102f0c <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f0c:	55                   	push   %ebp
80102f0d:	89 e5                	mov    %esp,%ebp
}
80102f0f:	c9                   	leave  
80102f10:	c3                   	ret    

80102f11 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f11:	55                   	push   %ebp
80102f12:	89 e5                	mov    %esp,%ebp
80102f14:	83 ec 14             	sub    $0x14,%esp
80102f17:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1a:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f1d:	6a 0f                	push   $0xf
80102f1f:	6a 70                	push   $0x70
80102f21:	e8 fe fd ff ff       	call   80102d24 <outb>
80102f26:	83 c4 08             	add    $0x8,%esp
  outb(IO_RTC+1, 0x0A);
80102f29:	6a 0a                	push   $0xa
80102f2b:	6a 71                	push   $0x71
80102f2d:	e8 f2 fd ff ff       	call   80102d24 <outb>
80102f32:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f35:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f3f:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f44:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f47:	8d 50 02             	lea    0x2(%eax),%edx
80102f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f4d:	c1 e8 04             	shr    $0x4,%eax
80102f50:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f53:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f57:	c1 e0 18             	shl    $0x18,%eax
80102f5a:	50                   	push   %eax
80102f5b:	68 c4 00 00 00       	push   $0xc4
80102f60:	e8 f0 fd ff ff       	call   80102d55 <lapicw>
80102f65:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f68:	68 00 c5 00 00       	push   $0xc500
80102f6d:	68 c0 00 00 00       	push   $0xc0
80102f72:	e8 de fd ff ff       	call   80102d55 <lapicw>
80102f77:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80102f7a:	68 c8 00 00 00       	push   $0xc8
80102f7f:	e8 88 ff ff ff       	call   80102f0c <microdelay>
80102f84:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80102f87:	68 00 85 00 00       	push   $0x8500
80102f8c:	68 c0 00 00 00       	push   $0xc0
80102f91:	e8 bf fd ff ff       	call   80102d55 <lapicw>
80102f96:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f99:	6a 64                	push   $0x64
80102f9b:	e8 6c ff ff ff       	call   80102f0c <microdelay>
80102fa0:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102faa:	eb 3c                	jmp    80102fe8 <lapicstartap+0xd7>
    lapicw(ICRHI, apicid<<24);
80102fac:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fb0:	c1 e0 18             	shl    $0x18,%eax
80102fb3:	50                   	push   %eax
80102fb4:	68 c4 00 00 00       	push   $0xc4
80102fb9:	e8 97 fd ff ff       	call   80102d55 <lapicw>
80102fbe:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc4:	c1 e8 0c             	shr    $0xc,%eax
80102fc7:	80 cc 06             	or     $0x6,%ah
80102fca:	50                   	push   %eax
80102fcb:	68 c0 00 00 00       	push   $0xc0
80102fd0:	e8 80 fd ff ff       	call   80102d55 <lapicw>
80102fd5:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80102fd8:	68 c8 00 00 00       	push   $0xc8
80102fdd:	e8 2a ff ff ff       	call   80102f0c <microdelay>
80102fe2:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fe5:	ff 45 fc             	incl   -0x4(%ebp)
80102fe8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fec:	7e be                	jle    80102fac <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102fee:	c9                   	leave  
80102fef:	c3                   	ret    

80102ff0 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102ff6:	83 ec 08             	sub    $0x8,%esp
80102ff9:	68 e4 81 10 80       	push   $0x801081e4
80102ffe:	68 80 f8 10 80       	push   $0x8010f880
80103003:	e8 5e 1b 00 00       	call   80104b66 <initlock>
80103008:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
8010300b:	83 ec 08             	sub    $0x8,%esp
8010300e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103011:	50                   	push   %eax
80103012:	6a 01                	push   $0x1
80103014:	e8 f7 e2 ff ff       	call   80101310 <readsb>
80103019:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
8010301c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103022:	89 d1                	mov    %edx,%ecx
80103024:	29 c1                	sub    %eax,%ecx
80103026:	89 c8                	mov    %ecx,%eax
80103028:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
8010302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103030:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
80103035:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
8010303c:	00 00 00 
  recover_from_log();
8010303f:	e8 a6 01 00 00       	call   801031ea <recover_from_log>
}
80103044:	c9                   	leave  
80103045:	c3                   	ret    

80103046 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103046:	55                   	push   %ebp
80103047:	89 e5                	mov    %esp,%ebp
80103049:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010304c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103053:	e9 8f 00 00 00       	jmp    801030e7 <install_trans+0xa1>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103058:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010305d:	03 45 f4             	add    -0xc(%ebp),%eax
80103060:	40                   	inc    %eax
80103061:	89 c2                	mov    %eax,%edx
80103063:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103068:	83 ec 08             	sub    $0x8,%esp
8010306b:	52                   	push   %edx
8010306c:	50                   	push   %eax
8010306d:	e8 43 d1 ff ff       	call   801001b5 <bread>
80103072:	83 c4 10             	add    $0x10,%esp
80103075:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010307b:	83 c0 10             	add    $0x10,%eax
8010307e:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103085:	89 c2                	mov    %eax,%edx
80103087:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010308c:	83 ec 08             	sub    $0x8,%esp
8010308f:	52                   	push   %edx
80103090:	50                   	push   %eax
80103091:	e8 1f d1 ff ff       	call   801001b5 <bread>
80103096:	83 c4 10             	add    $0x10,%esp
80103099:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010309f:	8d 50 18             	lea    0x18(%eax),%edx
801030a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030a5:	83 c0 18             	add    $0x18,%eax
801030a8:	83 ec 04             	sub    $0x4,%esp
801030ab:	68 00 02 00 00       	push   $0x200
801030b0:	52                   	push   %edx
801030b1:	50                   	push   %eax
801030b2:	e8 df 1d 00 00       	call   80104e96 <memmove>
801030b7:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801030ba:	83 ec 0c             	sub    $0xc,%esp
801030bd:	ff 75 ec             	pushl  -0x14(%ebp)
801030c0:	e8 29 d1 ff ff       	call   801001ee <bwrite>
801030c5:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801030c8:	83 ec 0c             	sub    $0xc,%esp
801030cb:	ff 75 f0             	pushl  -0x10(%ebp)
801030ce:	e8 59 d1 ff ff       	call   8010022c <brelse>
801030d3:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	ff 75 ec             	pushl  -0x14(%ebp)
801030dc:	e8 4b d1 ff ff       	call   8010022c <brelse>
801030e1:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030e4:	ff 45 f4             	incl   -0xc(%ebp)
801030e7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801030ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030ef:	0f 8f 63 ff ff ff    	jg     80103058 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801030f5:	c9                   	leave  
801030f6:	c3                   	ret    

801030f7 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030f7:	55                   	push   %ebp
801030f8:	89 e5                	mov    %esp,%ebp
801030fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801030fd:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103102:	89 c2                	mov    %eax,%edx
80103104:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103109:	83 ec 08             	sub    $0x8,%esp
8010310c:	52                   	push   %edx
8010310d:	50                   	push   %eax
8010310e:	e8 a2 d0 ff ff       	call   801001b5 <bread>
80103113:	83 c4 10             	add    $0x10,%esp
80103116:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010311c:	83 c0 18             	add    $0x18,%eax
8010311f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103122:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103125:	8b 00                	mov    (%eax),%eax
80103127:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
8010312c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103133:	eb 1a                	jmp    8010314f <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
80103135:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103138:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010313b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010313f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103142:	83 c2 10             	add    $0x10,%edx
80103145:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010314c:	ff 45 f4             	incl   -0xc(%ebp)
8010314f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103154:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103157:	7f dc                	jg     80103135 <read_head+0x3e>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103159:	83 ec 0c             	sub    $0xc,%esp
8010315c:	ff 75 f0             	pushl  -0x10(%ebp)
8010315f:	e8 c8 d0 ff ff       	call   8010022c <brelse>
80103164:	83 c4 10             	add    $0x10,%esp
}
80103167:	c9                   	leave  
80103168:	c3                   	ret    

80103169 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103169:	55                   	push   %ebp
8010316a:	89 e5                	mov    %esp,%ebp
8010316c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010316f:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103174:	89 c2                	mov    %eax,%edx
80103176:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010317b:	83 ec 08             	sub    $0x8,%esp
8010317e:	52                   	push   %edx
8010317f:	50                   	push   %eax
80103180:	e8 30 d0 ff ff       	call   801001b5 <bread>
80103185:	83 c4 10             	add    $0x10,%esp
80103188:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010318e:	83 c0 18             	add    $0x18,%eax
80103191:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103194:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
8010319a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010319d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010319f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031a6:	eb 1a                	jmp    801031c2 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031ab:	83 c0 10             	add    $0x10,%eax
801031ae:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
801031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031bb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031bf:	ff 45 f4             	incl   -0xc(%ebp)
801031c2:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031ca:	7f dc                	jg     801031a8 <write_head+0x3f>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031cc:	83 ec 0c             	sub    $0xc,%esp
801031cf:	ff 75 f0             	pushl  -0x10(%ebp)
801031d2:	e8 17 d0 ff ff       	call   801001ee <bwrite>
801031d7:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801031da:	83 ec 0c             	sub    $0xc,%esp
801031dd:	ff 75 f0             	pushl  -0x10(%ebp)
801031e0:	e8 47 d0 ff ff       	call   8010022c <brelse>
801031e5:	83 c4 10             	add    $0x10,%esp
}
801031e8:	c9                   	leave  
801031e9:	c3                   	ret    

801031ea <recover_from_log>:

static void
recover_from_log(void)
{
801031ea:	55                   	push   %ebp
801031eb:	89 e5                	mov    %esp,%ebp
801031ed:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031f0:	e8 02 ff ff ff       	call   801030f7 <read_head>
  install_trans(); // if committed, copy from log to disk
801031f5:	e8 4c fe ff ff       	call   80103046 <install_trans>
  log.lh.n = 0;
801031fa:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103201:	00 00 00 
  write_head(); // clear the log
80103204:	e8 60 ff ff ff       	call   80103169 <write_head>
}
80103209:	c9                   	leave  
8010320a:	c3                   	ret    

8010320b <begin_trans>:

void
begin_trans(void)
{
8010320b:	55                   	push   %ebp
8010320c:	89 e5                	mov    %esp,%ebp
8010320e:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103211:	83 ec 0c             	sub    $0xc,%esp
80103214:	68 80 f8 10 80       	push   $0x8010f880
80103219:	e8 69 19 00 00       	call   80104b87 <acquire>
8010321e:	83 c4 10             	add    $0x10,%esp
  while (log.busy) {
80103221:	eb 15                	jmp    80103238 <begin_trans+0x2d>
    sleep(&log, &log.lock);
80103223:	83 ec 08             	sub    $0x8,%esp
80103226:	68 80 f8 10 80       	push   $0x8010f880
8010322b:	68 80 f8 10 80       	push   $0x8010f880
80103230:	e8 4f 16 00 00       	call   80104884 <sleep>
80103235:	83 c4 10             	add    $0x10,%esp

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103238:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
8010323d:	85 c0                	test   %eax,%eax
8010323f:	75 e2                	jne    80103223 <begin_trans+0x18>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
80103241:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103248:	00 00 00 
  release(&log.lock);
8010324b:	83 ec 0c             	sub    $0xc,%esp
8010324e:	68 80 f8 10 80       	push   $0x8010f880
80103253:	e8 95 19 00 00       	call   80104bed <release>
80103258:	83 c4 10             	add    $0x10,%esp
}
8010325b:	c9                   	leave  
8010325c:	c3                   	ret    

8010325d <commit_trans>:

void
commit_trans(void)
{
8010325d:	55                   	push   %ebp
8010325e:	89 e5                	mov    %esp,%ebp
80103260:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103263:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103268:	85 c0                	test   %eax,%eax
8010326a:	7e 19                	jle    80103285 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
8010326c:	e8 f8 fe ff ff       	call   80103169 <write_head>
    install_trans(); // Now install writes to home locations
80103271:	e8 d0 fd ff ff       	call   80103046 <install_trans>
    log.lh.n = 0; 
80103276:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
8010327d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103280:	e8 e4 fe ff ff       	call   80103169 <write_head>
  }
  
  acquire(&log.lock);
80103285:	83 ec 0c             	sub    $0xc,%esp
80103288:	68 80 f8 10 80       	push   $0x8010f880
8010328d:	e8 f5 18 00 00       	call   80104b87 <acquire>
80103292:	83 c4 10             	add    $0x10,%esp
  log.busy = 0;
80103295:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
8010329c:	00 00 00 
  wakeup(&log);
8010329f:	83 ec 0c             	sub    $0xc,%esp
801032a2:	68 80 f8 10 80       	push   $0x8010f880
801032a7:	e8 c2 16 00 00       	call   8010496e <wakeup>
801032ac:	83 c4 10             	add    $0x10,%esp
  release(&log.lock);
801032af:	83 ec 0c             	sub    $0xc,%esp
801032b2:	68 80 f8 10 80       	push   $0x8010f880
801032b7:	e8 31 19 00 00       	call   80104bed <release>
801032bc:	83 c4 10             	add    $0x10,%esp
}
801032bf:	c9                   	leave  
801032c0:	c3                   	ret    

801032c1 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032c1:	55                   	push   %ebp
801032c2:	89 e5                	mov    %esp,%ebp
801032c4:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032c7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032cc:	83 f8 09             	cmp    $0x9,%eax
801032cf:	7f 10                	jg     801032e1 <log_write+0x20>
801032d1:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032d6:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
801032dc:	4a                   	dec    %edx
801032dd:	39 d0                	cmp    %edx,%eax
801032df:	7c 0d                	jl     801032ee <log_write+0x2d>
    panic("too big a transaction");
801032e1:	83 ec 0c             	sub    $0xc,%esp
801032e4:	68 e8 81 10 80       	push   $0x801081e8
801032e9:	e8 71 d2 ff ff       	call   8010055f <panic>
  if (!log.busy)
801032ee:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032f3:	85 c0                	test   %eax,%eax
801032f5:	75 0d                	jne    80103304 <log_write+0x43>
    panic("write outside of trans");
801032f7:	83 ec 0c             	sub    $0xc,%esp
801032fa:	68 fe 81 10 80       	push   $0x801081fe
801032ff:	e8 5b d2 ff ff       	call   8010055f <panic>

  for (i = 0; i < log.lh.n; i++) {
80103304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010330b:	eb 1c                	jmp    80103329 <log_write+0x68>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103310:	83 c0 10             	add    $0x10,%eax
80103313:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010331a:	89 c2                	mov    %eax,%edx
8010331c:	8b 45 08             	mov    0x8(%ebp),%eax
8010331f:	8b 40 08             	mov    0x8(%eax),%eax
80103322:	39 c2                	cmp    %eax,%edx
80103324:	74 0f                	je     80103335 <log_write+0x74>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103326:	ff 45 f4             	incl   -0xc(%ebp)
80103329:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010332e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103331:	7f da                	jg     8010330d <log_write+0x4c>
80103333:	eb 01                	jmp    80103336 <log_write+0x75>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103335:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103336:	8b 45 08             	mov    0x8(%ebp),%eax
80103339:	8b 40 08             	mov    0x8(%eax),%eax
8010333c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010333f:	83 c2 10             	add    $0x10,%edx
80103342:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103349:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010334e:	03 45 f4             	add    -0xc(%ebp),%eax
80103351:	40                   	inc    %eax
80103352:	89 c2                	mov    %eax,%edx
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	8b 40 04             	mov    0x4(%eax),%eax
8010335a:	83 ec 08             	sub    $0x8,%esp
8010335d:	52                   	push   %edx
8010335e:	50                   	push   %eax
8010335f:	e8 51 ce ff ff       	call   801001b5 <bread>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010336a:	8b 45 08             	mov    0x8(%ebp),%eax
8010336d:	8d 50 18             	lea    0x18(%eax),%edx
80103370:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103373:	83 c0 18             	add    $0x18,%eax
80103376:	83 ec 04             	sub    $0x4,%esp
80103379:	68 00 02 00 00       	push   $0x200
8010337e:	52                   	push   %edx
8010337f:	50                   	push   %eax
80103380:	e8 11 1b 00 00       	call   80104e96 <memmove>
80103385:	83 c4 10             	add    $0x10,%esp
  bwrite(lbuf);
80103388:	83 ec 0c             	sub    $0xc,%esp
8010338b:	ff 75 f0             	pushl  -0x10(%ebp)
8010338e:	e8 5b ce ff ff       	call   801001ee <bwrite>
80103393:	83 c4 10             	add    $0x10,%esp
  brelse(lbuf);
80103396:	83 ec 0c             	sub    $0xc,%esp
80103399:	ff 75 f0             	pushl  -0x10(%ebp)
8010339c:	e8 8b ce ff ff       	call   8010022c <brelse>
801033a1:	83 c4 10             	add    $0x10,%esp
  if (i == log.lh.n)
801033a4:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033ac:	75 0b                	jne    801033b9 <log_write+0xf8>
    log.lh.n++;
801033ae:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033b3:	40                   	inc    %eax
801033b4:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033b9:	8b 45 08             	mov    0x8(%ebp),%eax
801033bc:	8b 00                	mov    (%eax),%eax
801033be:	89 c2                	mov    %eax,%edx
801033c0:	83 ca 04             	or     $0x4,%edx
801033c3:	8b 45 08             	mov    0x8(%ebp),%eax
801033c6:	89 10                	mov    %edx,(%eax)
}
801033c8:	c9                   	leave  
801033c9:	c3                   	ret    
	...

801033cc <v2p>:
801033cc:	55                   	push   %ebp
801033cd:	89 e5                	mov    %esp,%ebp
801033cf:	8b 45 08             	mov    0x8(%ebp),%eax
801033d2:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033d7:	c9                   	leave  
801033d8:	c3                   	ret    

801033d9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033d9:	55                   	push   %ebp
801033da:	89 e5                	mov    %esp,%ebp
801033dc:	8b 45 08             	mov    0x8(%ebp),%eax
801033df:	2d 00 00 00 80       	sub    $0x80000000,%eax
801033e4:	c9                   	leave  
801033e5:	c3                   	ret    

801033e6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033e6:	55                   	push   %ebp
801033e7:	89 e5                	mov    %esp,%ebp
801033e9:	53                   	push   %ebx
801033ea:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801033ed:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033f0:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801033f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033f6:	89 c3                	mov    %eax,%ebx
801033f8:	89 d8                	mov    %ebx,%eax
801033fa:	f0 87 02             	lock xchg %eax,(%edx)
801033fd:	89 c3                	mov    %eax,%ebx
801033ff:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103402:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	5b                   	pop    %ebx
80103409:	c9                   	leave  
8010340a:	c3                   	ret    

8010340b <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010340b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
8010340f:	83 e4 f0             	and    $0xfffffff0,%esp
80103412:	ff 71 fc             	pushl  -0x4(%ecx)
80103415:	55                   	push   %ebp
80103416:	89 e5                	mov    %esp,%ebp
80103418:	51                   	push   %ecx
80103419:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010341c:	83 ec 08             	sub    $0x8,%esp
8010341f:	68 00 00 40 80       	push   $0x80400000
80103424:	68 fc 26 11 80       	push   $0x801126fc
80103429:	e8 df f5 ff ff       	call   80102a0d <kinit1>
8010342e:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103431:	e8 52 44 00 00       	call   80107888 <kvmalloc>
  mpinit();        // collect info about this machine
80103436:	e8 8b 04 00 00       	call   801038c6 <mpinit>
  lapicinit();
8010343b:	e8 37 f9 ff ff       	call   80102d77 <lapicinit>
  seginit();       // set up segments
80103440:	e8 20 3e 00 00       	call   80107265 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103445:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010344b:	8a 00                	mov    (%eax),%al
8010344d:	0f b6 c0             	movzbl %al,%eax
80103450:	83 ec 08             	sub    $0x8,%esp
80103453:	50                   	push   %eax
80103454:	68 15 82 10 80       	push   $0x80108215
80103459:	e8 62 cf ff ff       	call   801003c0 <cprintf>
8010345e:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103461:	e8 c0 06 00 00       	call   80103b26 <picinit>
  ioapicinit();    // another interrupt controller
80103466:	e8 a2 f4 ff ff       	call   8010290d <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010346b:	e8 60 d6 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
80103470:	e8 57 31 00 00       	call   801065cc <uartinit>
  pinit();         // process table
80103475:	e8 a9 0b 00 00       	call   80104023 <pinit>
  tvinit();        // trap vectors
8010347a:	e8 2e 2d 00 00       	call   801061ad <tvinit>
  binit();         // buffer cache
8010347f:	e8 b0 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103484:	e8 7b da ff ff       	call   80100f04 <fileinit>
  iinit();         // inode cache
80103489:	e8 4e e1 ff ff       	call   801015dc <iinit>
  ideinit();       // disk
8010348e:	e8 c0 f0 ff ff       	call   80102553 <ideinit>
  if(!ismp)
80103493:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103498:	85 c0                	test   %eax,%eax
8010349a:	75 05                	jne    801034a1 <main+0x96>
    timerinit();   // uniprocessor timer
8010349c:	e8 67 2c 00 00       	call   80106108 <timerinit>
  startothers();   // start other processors
801034a1:	e8 7e 00 00 00       	call   80103524 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034a6:	83 ec 08             	sub    $0x8,%esp
801034a9:	68 00 00 00 8e       	push   $0x8e000000
801034ae:	68 00 00 40 80       	push   $0x80400000
801034b3:	e8 8d f5 ff ff       	call   80102a45 <kinit2>
801034b8:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801034bb:	e8 82 0c 00 00       	call   80104142 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034c0:	e8 1a 00 00 00       	call   801034df <mpmain>

801034c5 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034c5:	55                   	push   %ebp
801034c6:	89 e5                	mov    %esp,%ebp
801034c8:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801034cb:	e8 cf 43 00 00       	call   8010789f <switchkvm>
  seginit();
801034d0:	e8 90 3d 00 00       	call   80107265 <seginit>
  lapicinit();
801034d5:	e8 9d f8 ff ff       	call   80102d77 <lapicinit>
  mpmain();
801034da:	e8 00 00 00 00       	call   801034df <mpmain>

801034df <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034df:	55                   	push   %ebp
801034e0:	89 e5                	mov    %esp,%ebp
801034e2:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034e5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034eb:	8a 00                	mov    (%eax),%al
801034ed:	0f b6 c0             	movzbl %al,%eax
801034f0:	83 ec 08             	sub    $0x8,%esp
801034f3:	50                   	push   %eax
801034f4:	68 2c 82 10 80       	push   $0x8010822c
801034f9:	e8 c2 ce ff ff       	call   801003c0 <cprintf>
801034fe:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103501:	e8 05 2e 00 00       	call   8010630b <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103506:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010350c:	05 a8 00 00 00       	add    $0xa8,%eax
80103511:	83 ec 08             	sub    $0x8,%esp
80103514:	6a 01                	push   $0x1
80103516:	50                   	push   %eax
80103517:	e8 ca fe ff ff       	call   801033e6 <xchg>
8010351c:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010351f:	e8 95 11 00 00       	call   801046b9 <scheduler>

80103524 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103524:	55                   	push   %ebp
80103525:	89 e5                	mov    %esp,%ebp
80103527:	53                   	push   %ebx
80103528:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010352b:	68 00 70 00 00       	push   $0x7000
80103530:	e8 a4 fe ff ff       	call   801033d9 <p2v>
80103535:	83 c4 04             	add    $0x4,%esp
80103538:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010353b:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103540:	83 ec 04             	sub    $0x4,%esp
80103543:	50                   	push   %eax
80103544:	68 0c b5 10 80       	push   $0x8010b50c
80103549:	ff 75 f0             	pushl  -0x10(%ebp)
8010354c:	e8 45 19 00 00       	call   80104e96 <memmove>
80103551:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103554:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
8010355b:	e9 98 00 00 00       	jmp    801035f8 <startothers+0xd4>
    if(c == cpus+cpunum())  // We've started already.
80103560:	e8 32 f9 ff ff       	call   80102e97 <cpunum>
80103565:	89 c2                	mov    %eax,%edx
80103567:	89 d0                	mov    %edx,%eax
80103569:	d1 e0                	shl    %eax
8010356b:	01 d0                	add    %edx,%eax
8010356d:	c1 e0 04             	shl    $0x4,%eax
80103570:	29 d0                	sub    %edx,%eax
80103572:	c1 e0 02             	shl    $0x2,%eax
80103575:	05 20 f9 10 80       	add    $0x8010f920,%eax
8010357a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010357d:	74 71                	je     801035f0 <startothers+0xcc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010357f:	e8 bf f5 ff ff       	call   80102b43 <kalloc>
80103584:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103587:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010358a:	83 e8 04             	sub    $0x4,%eax
8010358d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103590:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103596:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010359b:	83 e8 08             	sub    $0x8,%eax
8010359e:	c7 00 c5 34 10 80    	movl   $0x801034c5,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035a7:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035aa:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801035af:	83 ec 0c             	sub    $0xc,%esp
801035b2:	50                   	push   %eax
801035b3:	e8 14 fe ff ff       	call   801033cc <v2p>
801035b8:	83 c4 10             	add    $0x10,%esp
801035bb:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035bd:	83 ec 0c             	sub    $0xc,%esp
801035c0:	ff 75 f0             	pushl  -0x10(%ebp)
801035c3:	e8 04 fe ff ff       	call   801033cc <v2p>
801035c8:	83 c4 10             	add    $0x10,%esp
801035cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035ce:	8a 12                	mov    (%edx),%dl
801035d0:	0f b6 d2             	movzbl %dl,%edx
801035d3:	83 ec 08             	sub    $0x8,%esp
801035d6:	50                   	push   %eax
801035d7:	52                   	push   %edx
801035d8:	e8 34 f9 ff ff       	call   80102f11 <lapicstartap>
801035dd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035e0:	90                   	nop
801035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035e4:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	74 f3                	je     801035e1 <startothers+0xbd>
801035ee:	eb 01                	jmp    801035f1 <startothers+0xcd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035f0:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035f1:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035f8:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035fd:	89 c2                	mov    %eax,%edx
801035ff:	89 d0                	mov    %edx,%eax
80103601:	d1 e0                	shl    %eax
80103603:	01 d0                	add    %edx,%eax
80103605:	c1 e0 04             	shl    $0x4,%eax
80103608:	29 d0                	sub    %edx,%eax
8010360a:	c1 e0 02             	shl    $0x2,%eax
8010360d:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103612:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103615:	0f 87 45 ff ff ff    	ja     80103560 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
8010361b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010361e:	c9                   	leave  
8010361f:	c3                   	ret    

80103620 <p2v>:
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	8b 45 08             	mov    0x8(%ebp),%eax
80103626:	2d 00 00 00 80       	sub    $0x80000000,%eax
8010362b:	c9                   	leave  
8010362c:	c3                   	ret    

8010362d <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010362d:	55                   	push   %ebp
8010362e:	89 e5                	mov    %esp,%ebp
80103630:	53                   	push   %ebx
80103631:	83 ec 18             	sub    $0x18,%esp
80103634:	8b 45 08             	mov    0x8(%ebp),%eax
80103637:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010363b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010363e:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
80103642:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
80103646:	ec                   	in     (%dx),%al
80103647:	88 c3                	mov    %al,%bl
80103649:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010364c:	8a 45 fb             	mov    -0x5(%ebp),%al
}
8010364f:	83 c4 18             	add    $0x18,%esp
80103652:	5b                   	pop    %ebx
80103653:	c9                   	leave  
80103654:	c3                   	ret    

80103655 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103655:	55                   	push   %ebp
80103656:	89 e5                	mov    %esp,%ebp
80103658:	83 ec 08             	sub    $0x8,%esp
8010365b:	8b 45 08             	mov    0x8(%ebp),%eax
8010365e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103661:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103665:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103668:	8a 45 f8             	mov    -0x8(%ebp),%al
8010366b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010366e:	ee                   	out    %al,(%dx)
}
8010366f:	c9                   	leave  
80103670:	c3                   	ret    

80103671 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103671:	55                   	push   %ebp
80103672:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103674:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103679:	89 c2                	mov    %eax,%edx
8010367b:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
80103680:	89 d1                	mov    %edx,%ecx
80103682:	29 c1                	sub    %eax,%ecx
80103684:	89 c8                	mov    %ecx,%eax
80103686:	89 c2                	mov    %eax,%edx
80103688:	c1 fa 02             	sar    $0x2,%edx
8010368b:	89 d0                	mov    %edx,%eax
8010368d:	c1 e0 03             	shl    $0x3,%eax
80103690:	01 d0                	add    %edx,%eax
80103692:	c1 e0 03             	shl    $0x3,%eax
80103695:	01 d0                	add    %edx,%eax
80103697:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
8010369e:	01 c8                	add    %ecx,%eax
801036a0:	c1 e0 03             	shl    $0x3,%eax
801036a3:	01 d0                	add    %edx,%eax
801036a5:	c1 e0 03             	shl    $0x3,%eax
801036a8:	29 d0                	sub    %edx,%eax
801036aa:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
801036b1:	01 c8                	add    %ecx,%eax
801036b3:	c1 e0 02             	shl    $0x2,%eax
801036b6:	01 d0                	add    %edx,%eax
801036b8:	c1 e0 03             	shl    $0x3,%eax
801036bb:	29 d0                	sub    %edx,%eax
801036bd:	89 c1                	mov    %eax,%ecx
801036bf:	c1 e1 07             	shl    $0x7,%ecx
801036c2:	01 c8                	add    %ecx,%eax
801036c4:	d1 e0                	shl    %eax
801036c6:	01 d0                	add    %edx,%eax
}
801036c8:	c9                   	leave  
801036c9:	c3                   	ret    

801036ca <sum>:

static uchar
sum(uchar *addr, int len)
{
801036ca:	55                   	push   %ebp
801036cb:	89 e5                	mov    %esp,%ebp
801036cd:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801036d0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801036d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801036de:	eb 11                	jmp    801036f1 <sum+0x27>
    sum += addr[i];
801036e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036e3:	03 45 08             	add    0x8(%ebp),%eax
801036e6:	8a 00                	mov    (%eax),%al
801036e8:	0f b6 c0             	movzbl %al,%eax
801036eb:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036ee:	ff 45 fc             	incl   -0x4(%ebp)
801036f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036f7:	7c e7                	jl     801036e0 <sum+0x16>
    sum += addr[i];
  return sum;
801036f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036fc:	c9                   	leave  
801036fd:	c3                   	ret    

801036fe <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036fe:	55                   	push   %ebp
801036ff:	89 e5                	mov    %esp,%ebp
80103701:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103704:	ff 75 08             	pushl  0x8(%ebp)
80103707:	e8 14 ff ff ff       	call   80103620 <p2v>
8010370c:	83 c4 04             	add    $0x4,%esp
8010370f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103712:	8b 45 0c             	mov    0xc(%ebp),%eax
80103715:	03 45 f0             	add    -0x10(%ebp),%eax
80103718:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
8010371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010371e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103721:	eb 36                	jmp    80103759 <mpsearch1+0x5b>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103723:	83 ec 04             	sub    $0x4,%esp
80103726:	6a 04                	push   $0x4
80103728:	68 40 82 10 80       	push   $0x80108240
8010372d:	ff 75 f4             	pushl  -0xc(%ebp)
80103730:	e8 0c 17 00 00       	call   80104e41 <memcmp>
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	85 c0                	test   %eax,%eax
8010373a:	75 19                	jne    80103755 <mpsearch1+0x57>
8010373c:	83 ec 08             	sub    $0x8,%esp
8010373f:	6a 10                	push   $0x10
80103741:	ff 75 f4             	pushl  -0xc(%ebp)
80103744:	e8 81 ff ff ff       	call   801036ca <sum>
80103749:	83 c4 10             	add    $0x10,%esp
8010374c:	84 c0                	test   %al,%al
8010374e:	75 05                	jne    80103755 <mpsearch1+0x57>
      return (struct mp*)p;
80103750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103753:	eb 11                	jmp    80103766 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103755:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010375c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010375f:	72 c2                	jb     80103723 <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103761:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103766:	c9                   	leave  
80103767:	c3                   	ret    

80103768 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103768:	55                   	push   %ebp
80103769:	89 e5                	mov    %esp,%ebp
8010376b:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
8010376e:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103778:	83 c0 0f             	add    $0xf,%eax
8010377b:	8a 00                	mov    (%eax),%al
8010377d:	0f b6 c0             	movzbl %al,%eax
80103780:	89 c2                	mov    %eax,%edx
80103782:	c1 e2 08             	shl    $0x8,%edx
80103785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103788:	83 c0 0e             	add    $0xe,%eax
8010378b:	8a 00                	mov    (%eax),%al
8010378d:	0f b6 c0             	movzbl %al,%eax
80103790:	09 d0                	or     %edx,%eax
80103792:	c1 e0 04             	shl    $0x4,%eax
80103795:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103798:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010379c:	74 21                	je     801037bf <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
8010379e:	83 ec 08             	sub    $0x8,%esp
801037a1:	68 00 04 00 00       	push   $0x400
801037a6:	ff 75 f0             	pushl  -0x10(%ebp)
801037a9:	e8 50 ff ff ff       	call   801036fe <mpsearch1>
801037ae:	83 c4 10             	add    $0x10,%esp
801037b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037b8:	74 4f                	je     80103809 <mpsearch+0xa1>
      return mp;
801037ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037bd:	eb 5f                	jmp    8010381e <mpsearch+0xb6>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801037bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c2:	83 c0 14             	add    $0x14,%eax
801037c5:	8a 00                	mov    (%eax),%al
801037c7:	0f b6 c0             	movzbl %al,%eax
801037ca:	89 c2                	mov    %eax,%edx
801037cc:	c1 e2 08             	shl    $0x8,%edx
801037cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037d2:	83 c0 13             	add    $0x13,%eax
801037d5:	8a 00                	mov    (%eax),%al
801037d7:	0f b6 c0             	movzbl %al,%eax
801037da:	09 d0                	or     %edx,%eax
801037dc:	c1 e0 0a             	shl    $0xa,%eax
801037df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037e5:	2d 00 04 00 00       	sub    $0x400,%eax
801037ea:	83 ec 08             	sub    $0x8,%esp
801037ed:	68 00 04 00 00       	push   $0x400
801037f2:	50                   	push   %eax
801037f3:	e8 06 ff ff ff       	call   801036fe <mpsearch1>
801037f8:	83 c4 10             	add    $0x10,%esp
801037fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103802:	74 05                	je     80103809 <mpsearch+0xa1>
      return mp;
80103804:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103807:	eb 15                	jmp    8010381e <mpsearch+0xb6>
  }
  return mpsearch1(0xF0000, 0x10000);
80103809:	83 ec 08             	sub    $0x8,%esp
8010380c:	68 00 00 01 00       	push   $0x10000
80103811:	68 00 00 0f 00       	push   $0xf0000
80103816:	e8 e3 fe ff ff       	call   801036fe <mpsearch1>
8010381b:	83 c4 10             	add    $0x10,%esp
}
8010381e:	c9                   	leave  
8010381f:	c3                   	ret    

80103820 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103826:	e8 3d ff ff ff       	call   80103768 <mpsearch>
8010382b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010382e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103832:	74 0a                	je     8010383e <mpconfig+0x1e>
80103834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103837:	8b 40 04             	mov    0x4(%eax),%eax
8010383a:	85 c0                	test   %eax,%eax
8010383c:	75 07                	jne    80103845 <mpconfig+0x25>
    return 0;
8010383e:	b8 00 00 00 00       	mov    $0x0,%eax
80103843:	eb 7f                	jmp    801038c4 <mpconfig+0xa4>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103845:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103848:	8b 40 04             	mov    0x4(%eax),%eax
8010384b:	83 ec 0c             	sub    $0xc,%esp
8010384e:	50                   	push   %eax
8010384f:	e8 cc fd ff ff       	call   80103620 <p2v>
80103854:	83 c4 10             	add    $0x10,%esp
80103857:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010385a:	83 ec 04             	sub    $0x4,%esp
8010385d:	6a 04                	push   $0x4
8010385f:	68 45 82 10 80       	push   $0x80108245
80103864:	ff 75 f0             	pushl  -0x10(%ebp)
80103867:	e8 d5 15 00 00       	call   80104e41 <memcmp>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	85 c0                	test   %eax,%eax
80103871:	74 07                	je     8010387a <mpconfig+0x5a>
    return 0;
80103873:	b8 00 00 00 00       	mov    $0x0,%eax
80103878:	eb 4a                	jmp    801038c4 <mpconfig+0xa4>
  if(conf->version != 1 && conf->version != 4)
8010387a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387d:	8a 40 06             	mov    0x6(%eax),%al
80103880:	3c 01                	cmp    $0x1,%al
80103882:	74 11                	je     80103895 <mpconfig+0x75>
80103884:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103887:	8a 40 06             	mov    0x6(%eax),%al
8010388a:	3c 04                	cmp    $0x4,%al
8010388c:	74 07                	je     80103895 <mpconfig+0x75>
    return 0;
8010388e:	b8 00 00 00 00       	mov    $0x0,%eax
80103893:	eb 2f                	jmp    801038c4 <mpconfig+0xa4>
  if(sum((uchar*)conf, conf->length) != 0)
80103895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103898:	8b 40 04             	mov    0x4(%eax),%eax
8010389b:	0f b7 d0             	movzwl %ax,%edx
8010389e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a1:	83 ec 08             	sub    $0x8,%esp
801038a4:	52                   	push   %edx
801038a5:	50                   	push   %eax
801038a6:	e8 1f fe ff ff       	call   801036ca <sum>
801038ab:	83 c4 10             	add    $0x10,%esp
801038ae:	84 c0                	test   %al,%al
801038b0:	74 07                	je     801038b9 <mpconfig+0x99>
    return 0;
801038b2:	b8 00 00 00 00       	mov    $0x0,%eax
801038b7:	eb 0b                	jmp    801038c4 <mpconfig+0xa4>
  *pmp = mp;
801038b9:	8b 45 08             	mov    0x8(%ebp),%eax
801038bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038bf:	89 10                	mov    %edx,(%eax)
  return conf;
801038c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801038c4:	c9                   	leave  
801038c5:	c3                   	ret    

801038c6 <mpinit>:

void
mpinit(void)
{
801038c6:	55                   	push   %ebp
801038c7:	89 e5                	mov    %esp,%ebp
801038c9:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
801038cc:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
801038d3:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
801038d6:	83 ec 0c             	sub    $0xc,%esp
801038d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801038dc:	50                   	push   %eax
801038dd:	e8 3e ff ff ff       	call   80103820 <mpconfig>
801038e2:	83 c4 10             	add    $0x10,%esp
801038e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038ec:	0f 84 a1 01 00 00    	je     80103a93 <mpinit+0x1cd>
    return;
  ismp = 1;
801038f2:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801038f9:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ff:	8b 40 24             	mov    0x24(%eax),%eax
80103902:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103907:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390a:	83 c0 2c             	add    $0x2c,%eax
8010390d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103910:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103916:	8b 40 04             	mov    0x4(%eax),%eax
80103919:	0f b7 c0             	movzwl %ax,%eax
8010391c:	8d 04 02             	lea    (%edx,%eax,1),%eax
8010391f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103922:	e9 fe 00 00 00       	jmp    80103a25 <mpinit+0x15f>
    switch(*p){
80103927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010392a:	8a 00                	mov    (%eax),%al
8010392c:	0f b6 c0             	movzbl %al,%eax
8010392f:	83 f8 04             	cmp    $0x4,%eax
80103932:	0f 87 ca 00 00 00    	ja     80103a02 <mpinit+0x13c>
80103938:	8b 04 85 88 82 10 80 	mov    -0x7fef7d78(,%eax,4),%eax
8010393f:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103944:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103947:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010394a:	8a 40 01             	mov    0x1(%eax),%al
8010394d:	0f b6 d0             	movzbl %al,%edx
80103950:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103955:	39 c2                	cmp    %eax,%edx
80103957:	74 2a                	je     80103983 <mpinit+0xbd>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103959:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010395c:	8a 40 01             	mov    0x1(%eax),%al
8010395f:	0f b6 d0             	movzbl %al,%edx
80103962:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103967:	83 ec 04             	sub    $0x4,%esp
8010396a:	52                   	push   %edx
8010396b:	50                   	push   %eax
8010396c:	68 4a 82 10 80       	push   $0x8010824a
80103971:	e8 4a ca ff ff       	call   801003c0 <cprintf>
80103976:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103979:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103980:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103983:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103986:	8a 40 03             	mov    0x3(%eax),%al
80103989:	0f b6 c0             	movzbl %al,%eax
8010398c:	83 e0 02             	and    $0x2,%eax
8010398f:	85 c0                	test   %eax,%eax
80103991:	74 1f                	je     801039b2 <mpinit+0xec>
        bcpu = &cpus[ncpu];
80103993:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103998:	89 c2                	mov    %eax,%edx
8010399a:	89 d0                	mov    %edx,%eax
8010399c:	d1 e0                	shl    %eax
8010399e:	01 d0                	add    %edx,%eax
801039a0:	c1 e0 04             	shl    $0x4,%eax
801039a3:	29 d0                	sub    %edx,%eax
801039a5:	c1 e0 02             	shl    $0x2,%eax
801039a8:	05 20 f9 10 80       	add    $0x8010f920,%eax
801039ad:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
801039b2:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
801039b8:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039bd:	88 c1                	mov    %al,%cl
801039bf:	89 d0                	mov    %edx,%eax
801039c1:	d1 e0                	shl    %eax
801039c3:	01 d0                	add    %edx,%eax
801039c5:	c1 e0 04             	shl    $0x4,%eax
801039c8:	29 d0                	sub    %edx,%eax
801039ca:	c1 e0 02             	shl    $0x2,%eax
801039cd:	05 20 f9 10 80       	add    $0x8010f920,%eax
801039d2:	88 08                	mov    %cl,(%eax)
      ncpu++;
801039d4:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801039d9:	40                   	inc    %eax
801039da:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
801039df:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801039e3:	eb 40                	jmp    80103a25 <mpinit+0x15f>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801039e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039ee:	8a 40 01             	mov    0x1(%eax),%al
801039f1:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
801039f6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039fa:	eb 29                	jmp    80103a25 <mpinit+0x15f>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039fc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103a00:	eb 23                	jmp    80103a25 <mpinit+0x15f>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a05:	8a 00                	mov    (%eax),%al
80103a07:	0f b6 c0             	movzbl %al,%eax
80103a0a:	83 ec 08             	sub    $0x8,%esp
80103a0d:	50                   	push   %eax
80103a0e:	68 68 82 10 80       	push   $0x80108268
80103a13:	e8 a8 c9 ff ff       	call   801003c0 <cprintf>
80103a18:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103a1b:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
80103a22:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a2b:	0f 82 f6 fe ff ff    	jb     80103927 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103a31:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103a36:	85 c0                	test   %eax,%eax
80103a38:	75 1d                	jne    80103a57 <mpinit+0x191>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103a3a:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
80103a41:	00 00 00 
    lapic = 0;
80103a44:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a4b:	00 00 00 
    ioapicid = 0;
80103a4e:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
80103a55:	eb 3d                	jmp    80103a94 <mpinit+0x1ce>
  }

  if(mp->imcrp){
80103a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a5a:	8a 40 0c             	mov    0xc(%eax),%al
80103a5d:	84 c0                	test   %al,%al
80103a5f:	74 33                	je     80103a94 <mpinit+0x1ce>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a61:	83 ec 08             	sub    $0x8,%esp
80103a64:	6a 70                	push   $0x70
80103a66:	6a 22                	push   $0x22
80103a68:	e8 e8 fb ff ff       	call   80103655 <outb>
80103a6d:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	6a 23                	push   $0x23
80103a75:	e8 b3 fb ff ff       	call   8010362d <inb>
80103a7a:	83 c4 10             	add    $0x10,%esp
80103a7d:	83 c8 01             	or     $0x1,%eax
80103a80:	0f b6 c0             	movzbl %al,%eax
80103a83:	83 ec 08             	sub    $0x8,%esp
80103a86:	50                   	push   %eax
80103a87:	6a 23                	push   $0x23
80103a89:	e8 c7 fb ff ff       	call   80103655 <outb>
80103a8e:	83 c4 10             	add    $0x10,%esp
80103a91:	eb 01                	jmp    80103a94 <mpinit+0x1ce>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a93:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a94:	c9                   	leave  
80103a95:	c3                   	ret    
	...

80103a98 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a98:	55                   	push   %ebp
80103a99:	89 e5                	mov    %esp,%ebp
80103a9b:	83 ec 08             	sub    $0x8,%esp
80103a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80103aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103aa4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103aa8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103aab:	8a 45 f8             	mov    -0x8(%ebp),%al
80103aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ab1:	ee                   	out    %al,(%dx)
}
80103ab2:	c9                   	leave  
80103ab3:	c3                   	ret    

80103ab4 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	83 ec 04             	sub    $0x4,%esp
80103aba:	8b 45 08             	mov    0x8(%ebp),%eax
80103abd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ac4:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103acd:	0f b6 c0             	movzbl %al,%eax
80103ad0:	50                   	push   %eax
80103ad1:	6a 21                	push   $0x21
80103ad3:	e8 c0 ff ff ff       	call   80103a98 <outb>
80103ad8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ade:	66 c1 e8 08          	shr    $0x8,%ax
80103ae2:	0f b6 c0             	movzbl %al,%eax
80103ae5:	50                   	push   %eax
80103ae6:	68 a1 00 00 00       	push   $0xa1
80103aeb:	e8 a8 ff ff ff       	call   80103a98 <outb>
80103af0:	83 c4 08             	add    $0x8,%esp
}
80103af3:	c9                   	leave  
80103af4:	c3                   	ret    

80103af5 <picenable>:

void
picenable(int irq)
{
80103af5:	55                   	push   %ebp
80103af6:	89 e5                	mov    %esp,%ebp
80103af8:	53                   	push   %ebx
  picsetmask(irqmask & ~(1<<irq));
80103af9:	8b 45 08             	mov    0x8(%ebp),%eax
80103afc:	ba 01 00 00 00       	mov    $0x1,%edx
80103b01:	89 d3                	mov    %edx,%ebx
80103b03:	88 c1                	mov    %al,%cl
80103b05:	d3 e3                	shl    %cl,%ebx
80103b07:	89 d8                	mov    %ebx,%eax
80103b09:	89 c2                	mov    %eax,%edx
80103b0b:	f7 d2                	not    %edx
80103b0d:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103b13:	21 d0                	and    %edx,%eax
80103b15:	0f b7 c0             	movzwl %ax,%eax
80103b18:	50                   	push   %eax
80103b19:	e8 96 ff ff ff       	call   80103ab4 <picsetmask>
80103b1e:	83 c4 04             	add    $0x4,%esp
}
80103b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b24:	c9                   	leave  
80103b25:	c3                   	ret    

80103b26 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103b26:	55                   	push   %ebp
80103b27:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103b29:	68 ff 00 00 00       	push   $0xff
80103b2e:	6a 21                	push   $0x21
80103b30:	e8 63 ff ff ff       	call   80103a98 <outb>
80103b35:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103b38:	68 ff 00 00 00       	push   $0xff
80103b3d:	68 a1 00 00 00       	push   $0xa1
80103b42:	e8 51 ff ff ff       	call   80103a98 <outb>
80103b47:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b4a:	6a 11                	push   $0x11
80103b4c:	6a 20                	push   $0x20
80103b4e:	e8 45 ff ff ff       	call   80103a98 <outb>
80103b53:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b56:	6a 20                	push   $0x20
80103b58:	6a 21                	push   $0x21
80103b5a:	e8 39 ff ff ff       	call   80103a98 <outb>
80103b5f:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b62:	6a 04                	push   $0x4
80103b64:	6a 21                	push   $0x21
80103b66:	e8 2d ff ff ff       	call   80103a98 <outb>
80103b6b:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b6e:	6a 03                	push   $0x3
80103b70:	6a 21                	push   $0x21
80103b72:	e8 21 ff ff ff       	call   80103a98 <outb>
80103b77:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b7a:	6a 11                	push   $0x11
80103b7c:	68 a0 00 00 00       	push   $0xa0
80103b81:	e8 12 ff ff ff       	call   80103a98 <outb>
80103b86:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b89:	6a 28                	push   $0x28
80103b8b:	68 a1 00 00 00       	push   $0xa1
80103b90:	e8 03 ff ff ff       	call   80103a98 <outb>
80103b95:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b98:	6a 02                	push   $0x2
80103b9a:	68 a1 00 00 00       	push   $0xa1
80103b9f:	e8 f4 fe ff ff       	call   80103a98 <outb>
80103ba4:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ba7:	6a 03                	push   $0x3
80103ba9:	68 a1 00 00 00       	push   $0xa1
80103bae:	e8 e5 fe ff ff       	call   80103a98 <outb>
80103bb3:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bb6:	6a 68                	push   $0x68
80103bb8:	6a 20                	push   $0x20
80103bba:	e8 d9 fe ff ff       	call   80103a98 <outb>
80103bbf:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bc2:	6a 0a                	push   $0xa
80103bc4:	6a 20                	push   $0x20
80103bc6:	e8 cd fe ff ff       	call   80103a98 <outb>
80103bcb:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103bce:	6a 68                	push   $0x68
80103bd0:	68 a0 00 00 00       	push   $0xa0
80103bd5:	e8 be fe ff ff       	call   80103a98 <outb>
80103bda:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103bdd:	6a 0a                	push   $0xa
80103bdf:	68 a0 00 00 00       	push   $0xa0
80103be4:	e8 af fe ff ff       	call   80103a98 <outb>
80103be9:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103bec:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103bf2:	66 83 f8 ff          	cmp    $0xffffffff,%ax
80103bf6:	74 12                	je     80103c0a <picinit+0xe4>
    picsetmask(irqmask);
80103bf8:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103bfe:	0f b7 c0             	movzwl %ax,%eax
80103c01:	50                   	push   %eax
80103c02:	e8 ad fe ff ff       	call   80103ab4 <picsetmask>
80103c07:	83 c4 04             	add    $0x4,%esp
}
80103c0a:	c9                   	leave  
80103c0b:	c3                   	ret    

80103c0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c0c:	55                   	push   %ebp
80103c0d:	89 e5                	mov    %esp,%ebp
80103c0f:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c19:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c22:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c25:	8b 10                	mov    (%eax),%edx
80103c27:	8b 45 08             	mov    0x8(%ebp),%eax
80103c2a:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c2c:	e8 f0 d2 ff ff       	call   80100f21 <filealloc>
80103c31:	8b 55 08             	mov    0x8(%ebp),%edx
80103c34:	89 02                	mov    %eax,(%edx)
80103c36:	8b 45 08             	mov    0x8(%ebp),%eax
80103c39:	8b 00                	mov    (%eax),%eax
80103c3b:	85 c0                	test   %eax,%eax
80103c3d:	0f 84 c9 00 00 00    	je     80103d0c <pipealloc+0x100>
80103c43:	e8 d9 d2 ff ff       	call   80100f21 <filealloc>
80103c48:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c4b:	89 02                	mov    %eax,(%edx)
80103c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c50:	8b 00                	mov    (%eax),%eax
80103c52:	85 c0                	test   %eax,%eax
80103c54:	0f 84 b2 00 00 00    	je     80103d0c <pipealloc+0x100>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c5a:	e8 e4 ee ff ff       	call   80102b43 <kalloc>
80103c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c66:	0f 84 9f 00 00 00    	je     80103d0b <pipealloc+0xff>
    goto bad;
  p->readopen = 1;
80103c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6f:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c76:	00 00 00 
  p->writeopen = 1;
80103c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c7c:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c83:	00 00 00 
  p->nwrite = 0;
80103c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c89:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c90:	00 00 00 
  p->nread = 0;
80103c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c96:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c9d:	00 00 00 
  initlock(&p->lock, "pipe");
80103ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca3:	83 ec 08             	sub    $0x8,%esp
80103ca6:	68 9c 82 10 80       	push   $0x8010829c
80103cab:	50                   	push   %eax
80103cac:	e8 b5 0e 00 00       	call   80104b66 <initlock>
80103cb1:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb7:	8b 00                	mov    (%eax),%eax
80103cb9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103cc2:	8b 00                	mov    (%eax),%eax
80103cc4:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccb:	8b 00                	mov    (%eax),%eax
80103ccd:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd4:	8b 00                	mov    (%eax),%eax
80103cd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cd9:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cdf:	8b 00                	mov    (%eax),%eax
80103ce1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cea:	8b 00                	mov    (%eax),%eax
80103cec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf3:	8b 00                	mov    (%eax),%eax
80103cf5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cfc:	8b 00                	mov    (%eax),%eax
80103cfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d01:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d04:	b8 00 00 00 00       	mov    $0x0,%eax
80103d09:	eb 4f                	jmp    80103d5a <pipealloc+0x14e>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d0b:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d10:	74 0f                	je     80103d21 <pipealloc+0x115>
    kfree((char*)p);
80103d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d15:	83 ec 0c             	sub    $0xc,%esp
80103d18:	50                   	push   %eax
80103d19:	e8 89 ed ff ff       	call   80102aa7 <kfree>
80103d1e:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80103d21:	8b 45 08             	mov    0x8(%ebp),%eax
80103d24:	8b 00                	mov    (%eax),%eax
80103d26:	85 c0                	test   %eax,%eax
80103d28:	74 11                	je     80103d3b <pipealloc+0x12f>
    fileclose(*f0);
80103d2a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2d:	8b 00                	mov    (%eax),%eax
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	50                   	push   %eax
80103d33:	e8 a7 d2 ff ff       	call   80100fdf <fileclose>
80103d38:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d3e:	8b 00                	mov    (%eax),%eax
80103d40:	85 c0                	test   %eax,%eax
80103d42:	74 11                	je     80103d55 <pipealloc+0x149>
    fileclose(*f1);
80103d44:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d47:	8b 00                	mov    (%eax),%eax
80103d49:	83 ec 0c             	sub    $0xc,%esp
80103d4c:	50                   	push   %eax
80103d4d:	e8 8d d2 ff ff       	call   80100fdf <fileclose>
80103d52:	83 c4 10             	add    $0x10,%esp
  return -1;
80103d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d5a:	c9                   	leave  
80103d5b:	c3                   	ret    

80103d5c <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d5c:	55                   	push   %ebp
80103d5d:	89 e5                	mov    %esp,%ebp
80103d5f:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80103d62:	8b 45 08             	mov    0x8(%ebp),%eax
80103d65:	83 ec 0c             	sub    $0xc,%esp
80103d68:	50                   	push   %eax
80103d69:	e8 19 0e 00 00       	call   80104b87 <acquire>
80103d6e:	83 c4 10             	add    $0x10,%esp
  if(writable){
80103d71:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d75:	74 23                	je     80103d9a <pipeclose+0x3e>
    p->writeopen = 0;
80103d77:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d81:	00 00 00 
    wakeup(&p->nread);
80103d84:	8b 45 08             	mov    0x8(%ebp),%eax
80103d87:	05 34 02 00 00       	add    $0x234,%eax
80103d8c:	83 ec 0c             	sub    $0xc,%esp
80103d8f:	50                   	push   %eax
80103d90:	e8 d9 0b 00 00       	call   8010496e <wakeup>
80103d95:	83 c4 10             	add    $0x10,%esp
80103d98:	eb 21                	jmp    80103dbb <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80103d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9d:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103da4:	00 00 00 
    wakeup(&p->nwrite);
80103da7:	8b 45 08             	mov    0x8(%ebp),%eax
80103daa:	05 38 02 00 00       	add    $0x238,%eax
80103daf:	83 ec 0c             	sub    $0xc,%esp
80103db2:	50                   	push   %eax
80103db3:	e8 b6 0b 00 00       	call   8010496e <wakeup>
80103db8:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dbe:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	75 2d                	jne    80103df5 <pipeclose+0x99>
80103dc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dcb:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103dd1:	85 c0                	test   %eax,%eax
80103dd3:	75 20                	jne    80103df5 <pipeclose+0x99>
    release(&p->lock);
80103dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	50                   	push   %eax
80103ddc:	e8 0c 0e 00 00       	call   80104bed <release>
80103de1:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80103de4:	8b 45 08             	mov    0x8(%ebp),%eax
80103de7:	83 ec 0c             	sub    $0xc,%esp
80103dea:	50                   	push   %eax
80103deb:	e8 b7 ec ff ff       	call   80102aa7 <kfree>
80103df0:	83 c4 10             	add    $0x10,%esp
80103df3:	eb 0f                	jmp    80103e04 <pipeclose+0xa8>
  } else
    release(&p->lock);
80103df5:	8b 45 08             	mov    0x8(%ebp),%eax
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	50                   	push   %eax
80103dfc:	e8 ec 0d 00 00       	call   80104bed <release>
80103e01:	83 c4 10             	add    $0x10,%esp
}
80103e04:	c9                   	leave  
80103e05:	c3                   	ret    

80103e06 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e06:	55                   	push   %ebp
80103e07:	89 e5                	mov    %esp,%ebp
80103e09:	53                   	push   %ebx
80103e0a:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103e10:	83 ec 0c             	sub    $0xc,%esp
80103e13:	50                   	push   %eax
80103e14:	e8 6e 0d 00 00       	call   80104b87 <acquire>
80103e19:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80103e1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e23:	e9 ad 00 00 00       	jmp    80103ed5 <pipewrite+0xcf>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e28:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e31:	85 c0                	test   %eax,%eax
80103e33:	74 0d                	je     80103e42 <pipewrite+0x3c>
80103e35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e3b:	8b 40 24             	mov    0x24(%eax),%eax
80103e3e:	85 c0                	test   %eax,%eax
80103e40:	74 19                	je     80103e5b <pipewrite+0x55>
        release(&p->lock);
80103e42:	8b 45 08             	mov    0x8(%ebp),%eax
80103e45:	83 ec 0c             	sub    $0xc,%esp
80103e48:	50                   	push   %eax
80103e49:	e8 9f 0d 00 00       	call   80104bed <release>
80103e4e:	83 c4 10             	add    $0x10,%esp
        return -1;
80103e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e56:	e9 a8 00 00 00       	jmp    80103f03 <pipewrite+0xfd>
      }
      wakeup(&p->nread);
80103e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5e:	05 34 02 00 00       	add    $0x234,%eax
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	50                   	push   %eax
80103e67:	e8 02 0b 00 00       	call   8010496e <wakeup>
80103e6c:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e6f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e72:	8b 55 08             	mov    0x8(%ebp),%edx
80103e75:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e7b:	83 ec 08             	sub    $0x8,%esp
80103e7e:	50                   	push   %eax
80103e7f:	52                   	push   %edx
80103e80:	e8 ff 09 00 00       	call   80104884 <sleep>
80103e85:	83 c4 10             	add    $0x10,%esp
80103e88:	eb 01                	jmp    80103e8b <pipewrite+0x85>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e8a:	90                   	nop
80103e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e94:	8b 45 08             	mov    0x8(%ebp),%eax
80103e97:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e9d:	05 00 02 00 00       	add    $0x200,%eax
80103ea2:	39 c2                	cmp    %eax,%edx
80103ea4:	74 82                	je     80103e28 <pipewrite+0x22>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103eaf:	89 c3                	mov    %eax,%ebx
80103eb1:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eba:	03 55 0c             	add    0xc(%ebp),%edx
80103ebd:	8a 0a                	mov    (%edx),%cl
80103ebf:	8b 55 08             	mov    0x8(%ebp),%edx
80103ec2:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103ec6:	8d 50 01             	lea    0x1(%eax),%edx
80103ec9:	8b 45 08             	mov    0x8(%ebp),%eax
80103ecc:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ed2:	ff 45 f4             	incl   -0xc(%ebp)
80103ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed8:	3b 45 10             	cmp    0x10(%ebp),%eax
80103edb:	7c ad                	jl     80103e8a <pipewrite+0x84>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103edd:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee0:	05 34 02 00 00       	add    $0x234,%eax
80103ee5:	83 ec 0c             	sub    $0xc,%esp
80103ee8:	50                   	push   %eax
80103ee9:	e8 80 0a 00 00       	call   8010496e <wakeup>
80103eee:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef4:	83 ec 0c             	sub    $0xc,%esp
80103ef7:	50                   	push   %eax
80103ef8:	e8 f0 0c 00 00       	call   80104bed <release>
80103efd:	83 c4 10             	add    $0x10,%esp
  return n;
80103f00:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f06:	c9                   	leave  
80103f07:	c3                   	ret    

80103f08 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f08:	55                   	push   %ebp
80103f09:	89 e5                	mov    %esp,%ebp
80103f0b:	53                   	push   %ebx
80103f0c:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80103f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f12:	83 ec 0c             	sub    $0xc,%esp
80103f15:	50                   	push   %eax
80103f16:	e8 6c 0c 00 00       	call   80104b87 <acquire>
80103f1b:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f1e:	eb 3f                	jmp    80103f5f <piperead+0x57>
    if(proc->killed){
80103f20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f26:	8b 40 24             	mov    0x24(%eax),%eax
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	74 19                	je     80103f46 <piperead+0x3e>
      release(&p->lock);
80103f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f30:	83 ec 0c             	sub    $0xc,%esp
80103f33:	50                   	push   %eax
80103f34:	e8 b4 0c 00 00       	call   80104bed <release>
80103f39:	83 c4 10             	add    $0x10,%esp
      return -1;
80103f3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f41:	e9 bd 00 00 00       	jmp    80104003 <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f46:	8b 45 08             	mov    0x8(%ebp),%eax
80103f49:	8b 55 08             	mov    0x8(%ebp),%edx
80103f4c:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f52:	83 ec 08             	sub    $0x8,%esp
80103f55:	50                   	push   %eax
80103f56:	52                   	push   %edx
80103f57:	e8 28 09 00 00       	call   80104884 <sleep>
80103f5c:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f62:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f68:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f71:	39 c2                	cmp    %eax,%edx
80103f73:	75 0d                	jne    80103f82 <piperead+0x7a>
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f7e:	85 c0                	test   %eax,%eax
80103f80:	75 9e                	jne    80103f20 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f89:	eb 47                	jmp    80103fd2 <piperead+0xca>
    if(p->nread == p->nwrite)
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f94:	8b 45 08             	mov    0x8(%ebp),%eax
80103f97:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f9d:	39 c2                	cmp    %eax,%edx
80103f9f:	74 3b                	je     80103fdc <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fa4:	89 c2                	mov    %eax,%edx
80103fa6:	03 55 0c             	add    0xc(%ebp),%edx
80103fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fac:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103fb2:	89 c3                	mov    %eax,%ebx
80103fb4:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fba:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fbd:	8a 4c 19 34          	mov    0x34(%ecx,%ebx,1),%cl
80103fc1:	88 0a                	mov    %cl,(%edx)
80103fc3:	8d 50 01             	lea    0x1(%eax),%edx
80103fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc9:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fcf:	ff 45 f4             	incl   -0xc(%ebp)
80103fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd5:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fd8:	7c b1                	jl     80103f8b <piperead+0x83>
80103fda:	eb 01                	jmp    80103fdd <piperead+0xd5>
    if(p->nread == p->nwrite)
      break;
80103fdc:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe0:	05 38 02 00 00       	add    $0x238,%eax
80103fe5:	83 ec 0c             	sub    $0xc,%esp
80103fe8:	50                   	push   %eax
80103fe9:	e8 80 09 00 00       	call   8010496e <wakeup>
80103fee:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80103ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	50                   	push   %eax
80103ff8:	e8 f0 0b 00 00       	call   80104bed <release>
80103ffd:	83 c4 10             	add    $0x10,%esp
  return i;
80104000:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104003:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104006:	c9                   	leave  
80104007:	c3                   	ret    

80104008 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104008:	55                   	push   %ebp
80104009:	89 e5                	mov    %esp,%ebp
8010400b:	53                   	push   %ebx
8010400c:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010400f:	9c                   	pushf  
80104010:	5b                   	pop    %ebx
80104011:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104014:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104017:	83 c4 10             	add    $0x10,%esp
8010401a:	5b                   	pop    %ebx
8010401b:	c9                   	leave  
8010401c:	c3                   	ret    

8010401d <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010401d:	55                   	push   %ebp
8010401e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104020:	fb                   	sti    
}
80104021:	c9                   	leave  
80104022:	c3                   	ret    

80104023 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104023:	55                   	push   %ebp
80104024:	89 e5                	mov    %esp,%ebp
80104026:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104029:	83 ec 08             	sub    $0x8,%esp
8010402c:	68 a1 82 10 80       	push   $0x801082a1
80104031:	68 20 ff 10 80       	push   $0x8010ff20
80104036:	e8 2b 0b 00 00       	call   80104b66 <initlock>
8010403b:	83 c4 10             	add    $0x10,%esp
}
8010403e:	c9                   	leave  
8010403f:	c3                   	ret    

80104040 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	68 20 ff 10 80       	push   $0x8010ff20
8010404e:	e8 34 0b 00 00       	call   80104b87 <acquire>
80104053:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104056:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010405d:	eb 0e                	jmp    8010406d <allocproc+0x2d>
    if(p->state == UNUSED)
8010405f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104062:	8b 40 0c             	mov    0xc(%eax),%eax
80104065:	85 c0                	test   %eax,%eax
80104067:	74 28                	je     80104091 <allocproc+0x51>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104069:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010406d:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104072:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104075:	72 e8                	jb     8010405f <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104077:	83 ec 0c             	sub    $0xc,%esp
8010407a:	68 20 ff 10 80       	push   $0x8010ff20
8010407f:	e8 69 0b 00 00       	call   80104bed <release>
80104084:	83 c4 10             	add    $0x10,%esp
  return 0;
80104087:	b8 00 00 00 00       	mov    $0x0,%eax
8010408c:	e9 af 00 00 00       	jmp    80104140 <allocproc+0x100>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104091:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104095:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010409c:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801040a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a4:	89 42 10             	mov    %eax,0x10(%edx)
801040a7:	40                   	inc    %eax
801040a8:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	68 20 ff 10 80       	push   $0x8010ff20
801040b5:	e8 33 0b 00 00       	call   80104bed <release>
801040ba:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801040bd:	e8 81 ea ff ff       	call   80102b43 <kalloc>
801040c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040c5:	89 42 08             	mov    %eax,0x8(%edx)
801040c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040cb:	8b 40 08             	mov    0x8(%eax),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	75 11                	jne    801040e3 <allocproc+0xa3>
    p->state = UNUSED;
801040d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040dc:	b8 00 00 00 00       	mov    $0x0,%eax
801040e1:	eb 5d                	jmp    80104140 <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
801040e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e6:	8b 40 08             	mov    0x8(%eax),%eax
801040e9:	05 00 10 00 00       	add    $0x1000,%eax
801040ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040f1:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801040f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040fe:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104102:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104105:	ba 64 61 10 80       	mov    $0x80106164,%edx
8010410a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010410c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104110:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104113:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104116:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010411f:	83 ec 04             	sub    $0x4,%esp
80104122:	6a 14                	push   $0x14
80104124:	6a 00                	push   $0x0
80104126:	50                   	push   %eax
80104127:	e8 ae 0c 00 00       	call   80104dda <memset>
8010412c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104132:	8b 40 1c             	mov    0x1c(%eax),%eax
80104135:	ba 54 48 10 80       	mov    $0x80104854,%edx
8010413a:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104140:	c9                   	leave  
80104141:	c3                   	ret    

80104142 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104142:	55                   	push   %ebp
80104143:	89 e5                	mov    %esp,%ebp
80104145:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104148:	e8 f3 fe ff ff       	call   80104040 <allocproc>
8010414d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104158:	e8 78 36 00 00       	call   801077d5 <setupkvm>
8010415d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104160:	89 42 04             	mov    %eax,0x4(%edx)
80104163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104166:	8b 40 04             	mov    0x4(%eax),%eax
80104169:	85 c0                	test   %eax,%eax
8010416b:	75 0d                	jne    8010417a <userinit+0x38>
    panic("userinit: out of memory?");
8010416d:	83 ec 0c             	sub    $0xc,%esp
80104170:	68 a8 82 10 80       	push   $0x801082a8
80104175:	e8 e5 c3 ff ff       	call   8010055f <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010417a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010417f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104182:	8b 40 04             	mov    0x4(%eax),%eax
80104185:	83 ec 04             	sub    $0x4,%esp
80104188:	52                   	push   %edx
80104189:	68 e0 b4 10 80       	push   $0x8010b4e0
8010418e:	50                   	push   %eax
8010418f:	e8 8b 38 00 00       	call   80107a1f <inituvm>
80104194:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419a:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a3:	8b 40 18             	mov    0x18(%eax),%eax
801041a6:	83 ec 04             	sub    $0x4,%esp
801041a9:	6a 4c                	push   $0x4c
801041ab:	6a 00                	push   $0x0
801041ad:	50                   	push   %eax
801041ae:	e8 27 0c 00 00       	call   80104dda <memset>
801041b3:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b9:	8b 40 18             	mov    0x18(%eax),%eax
801041bc:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c5:	8b 40 18             	mov    0x18(%eax),%eax
801041c8:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d1:	8b 50 18             	mov    0x18(%eax),%edx
801041d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d7:	8b 40 18             	mov    0x18(%eax),%eax
801041da:	8b 40 2c             	mov    0x2c(%eax),%eax
801041dd:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801041e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e4:	8b 50 18             	mov    0x18(%eax),%edx
801041e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ea:	8b 40 18             	mov    0x18(%eax),%eax
801041ed:	8b 40 2c             	mov    0x2c(%eax),%eax
801041f0:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801041f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f7:	8b 40 18             	mov    0x18(%eax),%eax
801041fa:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104204:	8b 40 18             	mov    0x18(%eax),%eax
80104207:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010420e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104211:	8b 40 18             	mov    0x18(%eax),%eax
80104214:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010421e:	83 c0 6c             	add    $0x6c,%eax
80104221:	83 ec 04             	sub    $0x4,%esp
80104224:	6a 10                	push   $0x10
80104226:	68 c1 82 10 80       	push   $0x801082c1
8010422b:	50                   	push   %eax
8010422c:	e8 a4 0d 00 00       	call   80104fd5 <safestrcpy>
80104231:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104234:	83 ec 0c             	sub    $0xc,%esp
80104237:	68 ca 82 10 80       	push   $0x801082ca
8010423c:	e8 05 e2 ff ff       	call   80102446 <namei>
80104241:	83 c4 10             	add    $0x10,%esp
80104244:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104247:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010424a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104254:	c9                   	leave  
80104255:	c3                   	ret    

80104256 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104256:	55                   	push   %ebp
80104257:	89 e5                	mov    %esp,%ebp
80104259:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010425c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104262:	8b 00                	mov    (%eax),%eax
80104264:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104267:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010426b:	7e 31                	jle    8010429e <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010426d:	8b 45 08             	mov    0x8(%ebp),%eax
80104270:	89 c2                	mov    %eax,%edx
80104272:	03 55 f4             	add    -0xc(%ebp),%edx
80104275:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010427b:	8b 40 04             	mov    0x4(%eax),%eax
8010427e:	83 ec 04             	sub    $0x4,%esp
80104281:	52                   	push   %edx
80104282:	ff 75 f4             	pushl  -0xc(%ebp)
80104285:	50                   	push   %eax
80104286:	e8 ed 38 00 00       	call   80107b78 <allocuvm>
8010428b:	83 c4 10             	add    $0x10,%esp
8010428e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104295:	75 3e                	jne    801042d5 <growproc+0x7f>
      return -1;
80104297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429c:	eb 59                	jmp    801042f7 <growproc+0xa1>
  } else if(n < 0){
8010429e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801042a2:	79 31                	jns    801042d5 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042a4:	8b 45 08             	mov    0x8(%ebp),%eax
801042a7:	89 c2                	mov    %eax,%edx
801042a9:	03 55 f4             	add    -0xc(%ebp),%edx
801042ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b2:	8b 40 04             	mov    0x4(%eax),%eax
801042b5:	83 ec 04             	sub    $0x4,%esp
801042b8:	52                   	push   %edx
801042b9:	ff 75 f4             	pushl  -0xc(%ebp)
801042bc:	50                   	push   %eax
801042bd:	e8 7d 39 00 00       	call   80107c3f <deallocuvm>
801042c2:	83 c4 10             	add    $0x10,%esp
801042c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042cc:	75 07                	jne    801042d5 <growproc+0x7f>
      return -1;
801042ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d3:	eb 22                	jmp    801042f7 <growproc+0xa1>
  }
  proc->sz = sz;
801042d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042de:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801042e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e6:	83 ec 0c             	sub    $0xc,%esp
801042e9:	50                   	push   %eax
801042ea:	e8 cc 35 00 00       	call   801078bb <switchuvm>
801042ef:	83 c4 10             	add    $0x10,%esp
  return 0;
801042f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042f7:	c9                   	leave  
801042f8:	c3                   	ret    

801042f9 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801042f9:	55                   	push   %ebp
801042fa:	89 e5                	mov    %esp,%ebp
801042fc:	57                   	push   %edi
801042fd:	56                   	push   %esi
801042fe:	53                   	push   %ebx
801042ff:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104302:	e8 39 fd ff ff       	call   80104040 <allocproc>
80104307:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010430a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010430e:	75 0a                	jne    8010431a <fork+0x21>
    return -1;
80104310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104315:	e9 41 01 00 00       	jmp    8010445b <fork+0x162>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
8010431a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104320:	8b 10                	mov    (%eax),%edx
80104322:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104328:	8b 40 04             	mov    0x4(%eax),%eax
8010432b:	83 ec 08             	sub    $0x8,%esp
8010432e:	52                   	push   %edx
8010432f:	50                   	push   %eax
80104330:	e8 9a 3a 00 00       	call   80107dcf <copyuvm>
80104335:	83 c4 10             	add    $0x10,%esp
80104338:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010433b:	89 42 04             	mov    %eax,0x4(%edx)
8010433e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104341:	8b 40 04             	mov    0x4(%eax),%eax
80104344:	85 c0                	test   %eax,%eax
80104346:	75 30                	jne    80104378 <fork+0x7f>
    kfree(np->kstack);
80104348:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010434b:	8b 40 08             	mov    0x8(%eax),%eax
8010434e:	83 ec 0c             	sub    $0xc,%esp
80104351:	50                   	push   %eax
80104352:	e8 50 e7 ff ff       	call   80102aa7 <kfree>
80104357:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010435a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010435d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104364:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104367:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010436e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104373:	e9 e3 00 00 00       	jmp    8010445b <fork+0x162>
  }
  np->sz = proc->sz;
80104378:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010437e:	8b 10                	mov    (%eax),%edx
80104380:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104383:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104385:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010438c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438f:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104392:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104395:	8b 50 18             	mov    0x18(%eax),%edx
80104398:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010439e:	8b 40 18             	mov    0x18(%eax),%eax
801043a1:	89 c3                	mov    %eax,%ebx
801043a3:	b8 13 00 00 00       	mov    $0x13,%eax
801043a8:	89 d7                	mov    %edx,%edi
801043aa:	89 de                	mov    %ebx,%esi
801043ac:	89 c1                	mov    %eax,%ecx
801043ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043b3:	8b 40 18             	mov    0x18(%eax),%eax
801043b6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801043bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801043c4:	eb 40                	jmp    80104406 <fork+0x10d>
    if(proc->ofile[i])
801043c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043cf:	83 c2 08             	add    $0x8,%edx
801043d2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043d6:	85 c0                	test   %eax,%eax
801043d8:	74 29                	je     80104403 <fork+0x10a>
      np->ofile[i] = filedup(proc->ofile[i]);
801043da:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043e3:	83 c2 08             	add    $0x8,%edx
801043e6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043ea:	83 ec 0c             	sub    $0xc,%esp
801043ed:	50                   	push   %eax
801043ee:	e8 9b cb ff ff       	call   80100f8e <filedup>
801043f3:	83 c4 10             	add    $0x10,%esp
801043f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043f9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043fc:	83 c1 08             	add    $0x8,%ecx
801043ff:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104403:	ff 45 e4             	incl   -0x1c(%ebp)
80104406:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010440a:	7e ba                	jle    801043c6 <fork+0xcd>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010440c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104412:	8b 40 68             	mov    0x68(%eax),%eax
80104415:	83 ec 0c             	sub    $0xc,%esp
80104418:	50                   	push   %eax
80104419:	e8 52 d4 ff ff       	call   80101870 <idup>
8010441e:	83 c4 10             	add    $0x10,%esp
80104421:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104424:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104427:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010442a:	8b 40 10             	mov    0x10(%eax),%eax
8010442d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104430:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104433:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010443a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104440:	8d 50 6c             	lea    0x6c(%eax),%edx
80104443:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104446:	83 c0 6c             	add    $0x6c,%eax
80104449:	83 ec 04             	sub    $0x4,%esp
8010444c:	6a 10                	push   $0x10
8010444e:	52                   	push   %edx
8010444f:	50                   	push   %eax
80104450:	e8 80 0b 00 00       	call   80104fd5 <safestrcpy>
80104455:	83 c4 10             	add    $0x10,%esp
  return pid;
80104458:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010445b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445e:	83 c4 00             	add    $0x0,%esp
80104461:	5b                   	pop    %ebx
80104462:	5e                   	pop    %esi
80104463:	5f                   	pop    %edi
80104464:	c9                   	leave  
80104465:	c3                   	ret    

80104466 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104466:	55                   	push   %ebp
80104467:	89 e5                	mov    %esp,%ebp
80104469:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010446c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104473:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104478:	39 c2                	cmp    %eax,%edx
8010447a:	75 0d                	jne    80104489 <exit+0x23>
    panic("init exiting");
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	68 cc 82 10 80       	push   $0x801082cc
80104484:	e8 d6 c0 ff ff       	call   8010055f <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104490:	eb 47                	jmp    801044d9 <exit+0x73>
    if(proc->ofile[fd]){
80104492:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104498:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010449b:	83 c2 08             	add    $0x8,%edx
8010449e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044a2:	85 c0                	test   %eax,%eax
801044a4:	74 30                	je     801044d6 <exit+0x70>
      fileclose(proc->ofile[fd]);
801044a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044af:	83 c2 08             	add    $0x8,%edx
801044b2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	50                   	push   %eax
801044ba:	e8 20 cb ff ff       	call   80100fdf <fileclose>
801044bf:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801044c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044cb:	83 c2 08             	add    $0x8,%edx
801044ce:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801044d5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044d6:	ff 45 f0             	incl   -0x10(%ebp)
801044d9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801044dd:	7e b3                	jle    80104492 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801044df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e5:	8b 40 68             	mov    0x68(%eax),%eax
801044e8:	83 ec 0c             	sub    $0xc,%esp
801044eb:	50                   	push   %eax
801044ec:	e8 81 d5 ff ff       	call   80101a72 <iput>
801044f1:	83 c4 10             	add    $0x10,%esp
  proc->cwd = 0;
801044f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fa:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	68 20 ff 10 80       	push   $0x8010ff20
80104509:	e8 79 06 00 00       	call   80104b87 <acquire>
8010450e:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104511:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104517:	8b 40 14             	mov    0x14(%eax),%eax
8010451a:	83 ec 0c             	sub    $0xc,%esp
8010451d:	50                   	push   %eax
8010451e:	e8 0c 04 00 00       	call   8010492f <wakeup1>
80104523:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104526:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010452d:	eb 3c                	jmp    8010456b <exit+0x105>
    if(p->parent == proc){
8010452f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104532:	8b 50 14             	mov    0x14(%eax),%edx
80104535:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010453b:	39 c2                	cmp    %eax,%edx
8010453d:	75 28                	jne    80104567 <exit+0x101>
      p->parent = initproc;
8010453f:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
80104545:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104548:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454e:	8b 40 0c             	mov    0xc(%eax),%eax
80104551:	83 f8 05             	cmp    $0x5,%eax
80104554:	75 11                	jne    80104567 <exit+0x101>
        wakeup1(initproc);
80104556:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	50                   	push   %eax
8010455f:	e8 cb 03 00 00       	call   8010492f <wakeup1>
80104564:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104567:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010456b:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104570:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104573:	72 ba                	jb     8010452f <exit+0xc9>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104575:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010457b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104582:	e8 d8 01 00 00       	call   8010475f <sched>
  panic("zombie exit");
80104587:	83 ec 0c             	sub    $0xc,%esp
8010458a:	68 d9 82 10 80       	push   $0x801082d9
8010458f:	e8 cb bf ff ff       	call   8010055f <panic>

80104594 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	68 20 ff 10 80       	push   $0x8010ff20
801045a2:	e8 e0 05 00 00       	call   80104b87 <acquire>
801045a7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801045aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b1:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801045b8:	e9 a6 00 00 00       	jmp    80104663 <wait+0xcf>
      if(p->parent != proc)
801045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c0:	8b 50 14             	mov    0x14(%eax),%edx
801045c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045c9:	39 c2                	cmp    %eax,%edx
801045cb:	0f 85 8d 00 00 00    	jne    8010465e <wait+0xca>
        continue;
      havekids = 1;
801045d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045db:	8b 40 0c             	mov    0xc(%eax),%eax
801045de:	83 f8 05             	cmp    $0x5,%eax
801045e1:	75 7c                	jne    8010465f <wait+0xcb>
        // Found one.
        pid = p->pid;
801045e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e6:	8b 40 10             	mov    0x10(%eax),%eax
801045e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ef:	8b 40 08             	mov    0x8(%eax),%eax
801045f2:	83 ec 0c             	sub    $0xc,%esp
801045f5:	50                   	push   %eax
801045f6:	e8 ac e4 ff ff       	call   80102aa7 <kfree>
801045fb:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801045fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104601:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460b:	8b 40 04             	mov    0x4(%eax),%eax
8010460e:	83 ec 0c             	sub    $0xc,%esp
80104611:	50                   	push   %eax
80104612:	e8 e5 36 00 00       	call   80107cfc <freevm>
80104617:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
8010461a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104627:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010462e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104631:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104649:	83 ec 0c             	sub    $0xc,%esp
8010464c:	68 20 ff 10 80       	push   $0x8010ff20
80104651:	e8 97 05 00 00       	call   80104bed <release>
80104656:	83 c4 10             	add    $0x10,%esp
        return pid;
80104659:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010465c:	eb 59                	jmp    801046b7 <wait+0x123>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
8010465e:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010465f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104663:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104668:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010466b:	0f 82 4c ff ff ff    	jb     801045bd <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104671:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104675:	74 0d                	je     80104684 <wait+0xf0>
80104677:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467d:	8b 40 24             	mov    0x24(%eax),%eax
80104680:	85 c0                	test   %eax,%eax
80104682:	74 17                	je     8010469b <wait+0x107>
      release(&ptable.lock);
80104684:	83 ec 0c             	sub    $0xc,%esp
80104687:	68 20 ff 10 80       	push   $0x8010ff20
8010468c:	e8 5c 05 00 00       	call   80104bed <release>
80104691:	83 c4 10             	add    $0x10,%esp
      return -1;
80104694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104699:	eb 1c                	jmp    801046b7 <wait+0x123>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010469b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a1:	83 ec 08             	sub    $0x8,%esp
801046a4:	68 20 ff 10 80       	push   $0x8010ff20
801046a9:	50                   	push   %eax
801046aa:	e8 d5 01 00 00       	call   80104884 <sleep>
801046af:	83 c4 10             	add    $0x10,%esp
  }
801046b2:	e9 f3 fe ff ff       	jmp    801045aa <wait+0x16>
}
801046b7:	c9                   	leave  
801046b8:	c3                   	ret    

801046b9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801046b9:	55                   	push   %ebp
801046ba:	89 e5                	mov    %esp,%ebp
801046bc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801046bf:	e8 59 f9 ff ff       	call   8010401d <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801046c4:	83 ec 0c             	sub    $0xc,%esp
801046c7:	68 20 ff 10 80       	push   $0x8010ff20
801046cc:	e8 b6 04 00 00       	call   80104b87 <acquire>
801046d1:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d4:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801046db:	eb 63                	jmp    80104740 <scheduler+0x87>
      if(p->state != RUNNABLE)
801046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e0:	8b 40 0c             	mov    0xc(%eax),%eax
801046e3:	83 f8 03             	cmp    $0x3,%eax
801046e6:	75 53                	jne    8010473b <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
801046e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046eb:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
801046f1:	83 ec 0c             	sub    $0xc,%esp
801046f4:	ff 75 f4             	pushl  -0xc(%ebp)
801046f7:	e8 bf 31 00 00       	call   801078bb <switchuvm>
801046fc:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
801046ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104702:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104709:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104712:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104719:	83 c2 04             	add    $0x4,%edx
8010471c:	83 ec 08             	sub    $0x8,%esp
8010471f:	50                   	push   %eax
80104720:	52                   	push   %edx
80104721:	e8 1e 09 00 00       	call   80105044 <swtch>
80104726:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104729:	e8 71 31 00 00       	call   8010789f <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010472e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104735:	00 00 00 00 
80104739:	eb 01                	jmp    8010473c <scheduler+0x83>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
8010473b:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010473c:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104740:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104745:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104748:	72 93                	jb     801046dd <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
8010474a:	83 ec 0c             	sub    $0xc,%esp
8010474d:	68 20 ff 10 80       	push   $0x8010ff20
80104752:	e8 96 04 00 00       	call   80104bed <release>
80104757:	83 c4 10             	add    $0x10,%esp

  }
8010475a:	e9 60 ff ff ff       	jmp    801046bf <scheduler+0x6>

8010475f <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010475f:	55                   	push   %ebp
80104760:	89 e5                	mov    %esp,%ebp
80104762:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104765:	83 ec 0c             	sub    $0xc,%esp
80104768:	68 20 ff 10 80       	push   $0x8010ff20
8010476d:	e8 39 05 00 00       	call   80104cab <holding>
80104772:	83 c4 10             	add    $0x10,%esp
80104775:	85 c0                	test   %eax,%eax
80104777:	75 0d                	jne    80104786 <sched+0x27>
    panic("sched ptable.lock");
80104779:	83 ec 0c             	sub    $0xc,%esp
8010477c:	68 e5 82 10 80       	push   $0x801082e5
80104781:	e8 d9 bd ff ff       	call   8010055f <panic>
  if(cpu->ncli != 1)
80104786:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010478c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104792:	83 f8 01             	cmp    $0x1,%eax
80104795:	74 0d                	je     801047a4 <sched+0x45>
    panic("sched locks");
80104797:	83 ec 0c             	sub    $0xc,%esp
8010479a:	68 f7 82 10 80       	push   $0x801082f7
8010479f:	e8 bb bd ff ff       	call   8010055f <panic>
  if(proc->state == RUNNING)
801047a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047aa:	8b 40 0c             	mov    0xc(%eax),%eax
801047ad:	83 f8 04             	cmp    $0x4,%eax
801047b0:	75 0d                	jne    801047bf <sched+0x60>
    panic("sched running");
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	68 03 83 10 80       	push   $0x80108303
801047ba:	e8 a0 bd ff ff       	call   8010055f <panic>
  if(readeflags()&FL_IF)
801047bf:	e8 44 f8 ff ff       	call   80104008 <readeflags>
801047c4:	25 00 02 00 00       	and    $0x200,%eax
801047c9:	85 c0                	test   %eax,%eax
801047cb:	74 0d                	je     801047da <sched+0x7b>
    panic("sched interruptible");
801047cd:	83 ec 0c             	sub    $0xc,%esp
801047d0:	68 11 83 10 80       	push   $0x80108311
801047d5:	e8 85 bd ff ff       	call   8010055f <panic>
  intena = cpu->intena;
801047da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047e0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801047e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
801047e9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801047ef:	8b 40 04             	mov    0x4(%eax),%eax
801047f2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047f9:	83 c2 1c             	add    $0x1c,%edx
801047fc:	83 ec 08             	sub    $0x8,%esp
801047ff:	50                   	push   %eax
80104800:	52                   	push   %edx
80104801:	e8 3e 08 00 00       	call   80105044 <swtch>
80104806:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104809:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010480f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104812:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104818:	c9                   	leave  
80104819:	c3                   	ret    

8010481a <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010481a:	55                   	push   %ebp
8010481b:	89 e5                	mov    %esp,%ebp
8010481d:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104820:	83 ec 0c             	sub    $0xc,%esp
80104823:	68 20 ff 10 80       	push   $0x8010ff20
80104828:	e8 5a 03 00 00       	call   80104b87 <acquire>
8010482d:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104830:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104836:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010483d:	e8 1d ff ff ff       	call   8010475f <sched>
  release(&ptable.lock);
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 20 ff 10 80       	push   $0x8010ff20
8010484a:	e8 9e 03 00 00       	call   80104bed <release>
8010484f:	83 c4 10             	add    $0x10,%esp
}
80104852:	c9                   	leave  
80104853:	c3                   	ret    

80104854 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010485a:	83 ec 0c             	sub    $0xc,%esp
8010485d:	68 20 ff 10 80       	push   $0x8010ff20
80104862:	e8 86 03 00 00       	call   80104bed <release>
80104867:	83 c4 10             	add    $0x10,%esp

  if (first) {
8010486a:	a1 20 b0 10 80       	mov    0x8010b020,%eax
8010486f:	85 c0                	test   %eax,%eax
80104871:	74 0f                	je     80104882 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104873:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
8010487a:	00 00 00 
    initlog();
8010487d:	e8 6e e7 ff ff       	call   80102ff0 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104882:	c9                   	leave  
80104883:	c3                   	ret    

80104884 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104884:	55                   	push   %ebp
80104885:	89 e5                	mov    %esp,%ebp
80104887:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
8010488a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104890:	85 c0                	test   %eax,%eax
80104892:	75 0d                	jne    801048a1 <sleep+0x1d>
    panic("sleep");
80104894:	83 ec 0c             	sub    $0xc,%esp
80104897:	68 25 83 10 80       	push   $0x80108325
8010489c:	e8 be bc ff ff       	call   8010055f <panic>

  if(lk == 0)
801048a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801048a5:	75 0d                	jne    801048b4 <sleep+0x30>
    panic("sleep without lk");
801048a7:	83 ec 0c             	sub    $0xc,%esp
801048aa:	68 2b 83 10 80       	push   $0x8010832b
801048af:	e8 ab bc ff ff       	call   8010055f <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801048b4:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
801048bb:	74 1e                	je     801048db <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	68 20 ff 10 80       	push   $0x8010ff20
801048c5:	e8 bd 02 00 00       	call   80104b87 <acquire>
801048ca:	83 c4 10             	add    $0x10,%esp
    release(lk);
801048cd:	83 ec 0c             	sub    $0xc,%esp
801048d0:	ff 75 0c             	pushl  0xc(%ebp)
801048d3:	e8 15 03 00 00       	call   80104bed <release>
801048d8:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
801048db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e1:	8b 55 08             	mov    0x8(%ebp),%edx
801048e4:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
801048e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ed:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801048f4:	e8 66 fe ff ff       	call   8010475f <sched>

  // Tidy up.
  proc->chan = 0;
801048f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ff:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104906:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010490d:	74 1e                	je     8010492d <sleep+0xa9>
    release(&ptable.lock);
8010490f:	83 ec 0c             	sub    $0xc,%esp
80104912:	68 20 ff 10 80       	push   $0x8010ff20
80104917:	e8 d1 02 00 00       	call   80104bed <release>
8010491c:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	ff 75 0c             	pushl  0xc(%ebp)
80104925:	e8 5d 02 00 00       	call   80104b87 <acquire>
8010492a:	83 c4 10             	add    $0x10,%esp
  }
}
8010492d:	c9                   	leave  
8010492e:	c3                   	ret    

8010492f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010492f:	55                   	push   %ebp
80104930:	89 e5                	mov    %esp,%ebp
80104932:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104935:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
8010493c:	eb 24                	jmp    80104962 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010493e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104941:	8b 40 0c             	mov    0xc(%eax),%eax
80104944:	83 f8 02             	cmp    $0x2,%eax
80104947:	75 15                	jne    8010495e <wakeup1+0x2f>
80104949:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010494c:	8b 40 20             	mov    0x20(%eax),%eax
8010494f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104952:	75 0a                	jne    8010495e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104954:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104957:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010495e:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104962:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104967:	39 45 fc             	cmp    %eax,-0x4(%ebp)
8010496a:	72 d2                	jb     8010493e <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010496c:	c9                   	leave  
8010496d:	c3                   	ret    

8010496e <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010496e:	55                   	push   %ebp
8010496f:	89 e5                	mov    %esp,%ebp
80104971:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	68 20 ff 10 80       	push   $0x8010ff20
8010497c:	e8 06 02 00 00       	call   80104b87 <acquire>
80104981:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	ff 75 08             	pushl  0x8(%ebp)
8010498a:	e8 a0 ff ff ff       	call   8010492f <wakeup1>
8010498f:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104992:	83 ec 0c             	sub    $0xc,%esp
80104995:	68 20 ff 10 80       	push   $0x8010ff20
8010499a:	e8 4e 02 00 00       	call   80104bed <release>
8010499f:	83 c4 10             	add    $0x10,%esp
}
801049a2:	c9                   	leave  
801049a3:	c3                   	ret    

801049a4 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801049aa:	83 ec 0c             	sub    $0xc,%esp
801049ad:	68 20 ff 10 80       	push   $0x8010ff20
801049b2:	e8 d0 01 00 00       	call   80104b87 <acquire>
801049b7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ba:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801049c1:	eb 45                	jmp    80104a08 <kill+0x64>
    if(p->pid == pid){
801049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c6:	8b 40 10             	mov    0x10(%eax),%eax
801049c9:	3b 45 08             	cmp    0x8(%ebp),%eax
801049cc:	75 36                	jne    80104a04 <kill+0x60>
      p->killed = 1;
801049ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049db:	8b 40 0c             	mov    0xc(%eax),%eax
801049de:	83 f8 02             	cmp    $0x2,%eax
801049e1:	75 0a                	jne    801049ed <kill+0x49>
        p->state = RUNNABLE;
801049e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049ed:	83 ec 0c             	sub    $0xc,%esp
801049f0:	68 20 ff 10 80       	push   $0x8010ff20
801049f5:	e8 f3 01 00 00       	call   80104bed <release>
801049fa:	83 c4 10             	add    $0x10,%esp
      return 0;
801049fd:	b8 00 00 00 00       	mov    $0x0,%eax
80104a02:	eb 23                	jmp    80104a27 <kill+0x83>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a04:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a08:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104a0d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104a10:	72 b1                	jb     801049c3 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104a12:	83 ec 0c             	sub    $0xc,%esp
80104a15:	68 20 ff 10 80       	push   $0x8010ff20
80104a1a:	e8 ce 01 00 00       	call   80104bed <release>
80104a1f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a27:	c9                   	leave  
80104a28:	c3                   	ret    

80104a29 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a29:	55                   	push   %ebp
80104a2a:	89 e5                	mov    %esp,%ebp
80104a2c:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2f:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104a36:	e9 d4 00 00 00       	jmp    80104b0f <procdump+0xe6>
    if(p->state == UNUSED)
80104a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a3e:	8b 40 0c             	mov    0xc(%eax),%eax
80104a41:	85 c0                	test   %eax,%eax
80104a43:	0f 84 c1 00 00 00    	je     80104b0a <procdump+0xe1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4c:	8b 40 0c             	mov    0xc(%eax),%eax
80104a4f:	83 f8 05             	cmp    $0x5,%eax
80104a52:	77 23                	ja     80104a77 <procdump+0x4e>
80104a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a57:	8b 40 0c             	mov    0xc(%eax),%eax
80104a5a:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104a61:	85 c0                	test   %eax,%eax
80104a63:	74 12                	je     80104a77 <procdump+0x4e>
      state = states[p->state];
80104a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a68:	8b 40 0c             	mov    0xc(%eax),%eax
80104a6b:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104a72:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104a75:	eb 07                	jmp    80104a7e <procdump+0x55>
    else
      state = "???";
80104a77:	c7 45 ec 3c 83 10 80 	movl   $0x8010833c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a81:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a87:	8b 40 10             	mov    0x10(%eax),%eax
80104a8a:	52                   	push   %edx
80104a8b:	ff 75 ec             	pushl  -0x14(%ebp)
80104a8e:	50                   	push   %eax
80104a8f:	68 40 83 10 80       	push   $0x80108340
80104a94:	e8 27 b9 ff ff       	call   801003c0 <cprintf>
80104a99:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9f:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa2:	83 f8 02             	cmp    $0x2,%eax
80104aa5:	75 51                	jne    80104af8 <procdump+0xcf>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aaa:	8b 40 1c             	mov    0x1c(%eax),%eax
80104aad:	8b 40 0c             	mov    0xc(%eax),%eax
80104ab0:	83 c0 08             	add    $0x8,%eax
80104ab3:	83 ec 08             	sub    $0x8,%esp
80104ab6:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104ab9:	52                   	push   %edx
80104aba:	50                   	push   %eax
80104abb:	e8 7e 01 00 00       	call   80104c3e <getcallerpcs>
80104ac0:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ac3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104aca:	eb 1b                	jmp    80104ae7 <procdump+0xbe>
        cprintf(" %p", pc[i]);
80104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acf:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ad3:	83 ec 08             	sub    $0x8,%esp
80104ad6:	50                   	push   %eax
80104ad7:	68 49 83 10 80       	push   $0x80108349
80104adc:	e8 df b8 ff ff       	call   801003c0 <cprintf>
80104ae1:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ae4:	ff 45 f4             	incl   -0xc(%ebp)
80104ae7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104aeb:	7f 0b                	jg     80104af8 <procdump+0xcf>
80104aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104af4:	85 c0                	test   %eax,%eax
80104af6:	75 d4                	jne    80104acc <procdump+0xa3>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104af8:	83 ec 0c             	sub    $0xc,%esp
80104afb:	68 4d 83 10 80       	push   $0x8010834d
80104b00:	e8 bb b8 ff ff       	call   801003c0 <cprintf>
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	eb 01                	jmp    80104b0b <procdump+0xe2>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104b0a:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0b:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104b0f:	b8 54 1e 11 80       	mov    $0x80111e54,%eax
80104b14:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80104b17:	0f 82 1e ff ff ff    	jb     80104a3b <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104b1d:	c9                   	leave  
80104b1e:	c3                   	ret    
	...

80104b20 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b27:	9c                   	pushf  
80104b28:	5b                   	pop    %ebx
80104b29:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104b2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	5b                   	pop    %ebx
80104b33:	c9                   	leave  
80104b34:	c3                   	ret    

80104b35 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104b35:	55                   	push   %ebp
80104b36:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104b38:	fa                   	cli    
}
80104b39:	c9                   	leave  
80104b3a:	c3                   	ret    

80104b3b <sti>:

static inline void
sti(void)
{
80104b3b:	55                   	push   %ebp
80104b3c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104b3e:	fb                   	sti    
}
80104b3f:	c9                   	leave  
80104b40:	c3                   	ret    

80104b41 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104b41:	55                   	push   %ebp
80104b42:	89 e5                	mov    %esp,%ebp
80104b44:	53                   	push   %ebx
80104b45:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104b48:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104b4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104b51:	89 c3                	mov    %eax,%ebx
80104b53:	89 d8                	mov    %ebx,%eax
80104b55:	f0 87 02             	lock xchg %eax,(%edx)
80104b58:	89 c3                	mov    %eax,%ebx
80104b5a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104b5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104b60:	83 c4 10             	add    $0x10,%esp
80104b63:	5b                   	pop    %ebx
80104b64:	c9                   	leave  
80104b65:	c3                   	ret    

80104b66 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b66:	55                   	push   %ebp
80104b67:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104b69:	8b 45 08             	mov    0x8(%ebp),%eax
80104b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104b72:	8b 45 08             	mov    0x8(%ebp),%eax
80104b75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104b7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    

80104b87 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104b87:	55                   	push   %ebp
80104b88:	89 e5                	mov    %esp,%ebp
80104b8a:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104b8d:	e8 43 01 00 00       	call   80104cd5 <pushcli>
  if(holding(lk))
80104b92:	8b 45 08             	mov    0x8(%ebp),%eax
80104b95:	83 ec 0c             	sub    $0xc,%esp
80104b98:	50                   	push   %eax
80104b99:	e8 0d 01 00 00       	call   80104cab <holding>
80104b9e:	83 c4 10             	add    $0x10,%esp
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	74 0d                	je     80104bb2 <acquire+0x2b>
    panic("acquire");
80104ba5:	83 ec 0c             	sub    $0xc,%esp
80104ba8:	68 79 83 10 80       	push   $0x80108379
80104bad:	e8 ad b9 ff ff       	call   8010055f <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104bb2:	90                   	nop
80104bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104bb6:	83 ec 08             	sub    $0x8,%esp
80104bb9:	6a 01                	push   $0x1
80104bbb:	50                   	push   %eax
80104bbc:	e8 80 ff ff ff       	call   80104b41 <xchg>
80104bc1:	83 c4 10             	add    $0x10,%esp
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	75 eb                	jne    80104bb3 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bcb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104bd2:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bd8:	83 c0 0c             	add    $0xc,%eax
80104bdb:	83 ec 08             	sub    $0x8,%esp
80104bde:	50                   	push   %eax
80104bdf:	8d 45 08             	lea    0x8(%ebp),%eax
80104be2:	50                   	push   %eax
80104be3:	e8 56 00 00 00       	call   80104c3e <getcallerpcs>
80104be8:	83 c4 10             	add    $0x10,%esp
}
80104beb:	c9                   	leave  
80104bec:	c3                   	ret    

80104bed <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104bed:	55                   	push   %ebp
80104bee:	89 e5                	mov    %esp,%ebp
80104bf0:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104bf3:	83 ec 0c             	sub    $0xc,%esp
80104bf6:	ff 75 08             	pushl  0x8(%ebp)
80104bf9:	e8 ad 00 00 00       	call   80104cab <holding>
80104bfe:	83 c4 10             	add    $0x10,%esp
80104c01:	85 c0                	test   %eax,%eax
80104c03:	75 0d                	jne    80104c12 <release+0x25>
    panic("release");
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	68 81 83 10 80       	push   $0x80108381
80104c0d:	e8 4d b9 ff ff       	call   8010055f <panic>

  lk->pcs[0] = 0;
80104c12:	8b 45 08             	mov    0x8(%ebp),%eax
80104c15:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80104c1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104c26:	8b 45 08             	mov    0x8(%ebp),%eax
80104c29:	83 ec 08             	sub    $0x8,%esp
80104c2c:	6a 00                	push   $0x0
80104c2e:	50                   	push   %eax
80104c2f:	e8 0d ff ff ff       	call   80104b41 <xchg>
80104c34:	83 c4 10             	add    $0x10,%esp

  popcli();
80104c37:	e8 df 00 00 00       	call   80104d1b <popcli>
}
80104c3c:	c9                   	leave  
80104c3d:	c3                   	ret    

80104c3e <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c3e:	55                   	push   %ebp
80104c3f:	89 e5                	mov    %esp,%ebp
80104c41:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104c44:	8b 45 08             	mov    0x8(%ebp),%eax
80104c47:	83 e8 08             	sub    $0x8,%eax
80104c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104c54:	eb 33                	jmp    80104c89 <getcallerpcs+0x4b>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c56:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104c5a:	74 47                	je     80104ca3 <getcallerpcs+0x65>
80104c5c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104c63:	76 3e                	jbe    80104ca3 <getcallerpcs+0x65>
80104c65:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104c69:	74 38                	je     80104ca3 <getcallerpcs+0x65>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c6e:	c1 e0 02             	shl    $0x2,%eax
80104c71:	03 45 0c             	add    0xc(%ebp),%eax
80104c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c77:	83 c2 04             	add    $0x4,%edx
80104c7a:	8b 12                	mov    (%edx),%edx
80104c7c:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80104c7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104c81:	8b 00                	mov    (%eax),%eax
80104c83:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c86:	ff 45 f8             	incl   -0x8(%ebp)
80104c89:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104c8d:	7e c7                	jle    80104c56 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c8f:	eb 12                	jmp    80104ca3 <getcallerpcs+0x65>
    pcs[i] = 0;
80104c91:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104c94:	c1 e0 02             	shl    $0x2,%eax
80104c97:	03 45 0c             	add    0xc(%ebp),%eax
80104c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ca0:	ff 45 f8             	incl   -0x8(%ebp)
80104ca3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104ca7:	7e e8                	jle    80104c91 <getcallerpcs+0x53>
    pcs[i] = 0;
}
80104ca9:	c9                   	leave  
80104caa:	c3                   	ret    

80104cab <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104cab:	55                   	push   %ebp
80104cac:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104cae:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb1:	8b 00                	mov    (%eax),%eax
80104cb3:	85 c0                	test   %eax,%eax
80104cb5:	74 17                	je     80104cce <holding+0x23>
80104cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cba:	8b 50 08             	mov    0x8(%eax),%edx
80104cbd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cc3:	39 c2                	cmp    %eax,%edx
80104cc5:	75 07                	jne    80104cce <holding+0x23>
80104cc7:	b8 01 00 00 00       	mov    $0x1,%eax
80104ccc:	eb 05                	jmp    80104cd3 <holding+0x28>
80104cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104cd3:	c9                   	leave  
80104cd4:	c3                   	ret    

80104cd5 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cd5:	55                   	push   %ebp
80104cd6:	89 e5                	mov    %esp,%ebp
80104cd8:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104cdb:	e8 40 fe ff ff       	call   80104b20 <readeflags>
80104ce0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104ce3:	e8 4d fe ff ff       	call   80104b35 <cli>
  if(cpu->ncli++ == 0)
80104ce8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cee:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104cf4:	85 d2                	test   %edx,%edx
80104cf6:	0f 94 c1             	sete   %cl
80104cf9:	42                   	inc    %edx
80104cfa:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104d00:	84 c9                	test   %cl,%cl
80104d02:	74 15                	je     80104d19 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80104d04:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104d0d:	81 e2 00 02 00 00    	and    $0x200,%edx
80104d13:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d19:	c9                   	leave  
80104d1a:	c3                   	ret    

80104d1b <popcli>:

void
popcli(void)
{
80104d1b:	55                   	push   %ebp
80104d1c:	89 e5                	mov    %esp,%ebp
80104d1e:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80104d21:	e8 fa fd ff ff       	call   80104b20 <readeflags>
80104d26:	25 00 02 00 00       	and    $0x200,%eax
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	74 0d                	je     80104d3c <popcli+0x21>
    panic("popcli - interruptible");
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	68 89 83 10 80       	push   $0x80108389
80104d37:	e8 23 b8 ff ff       	call   8010055f <panic>
  if(--cpu->ncli < 0)
80104d3c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d42:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104d48:	4a                   	dec    %edx
80104d49:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104d4f:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d55:	85 c0                	test   %eax,%eax
80104d57:	79 0d                	jns    80104d66 <popcli+0x4b>
    panic("popcli");
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	68 a0 83 10 80       	push   $0x801083a0
80104d61:	e8 f9 b7 ff ff       	call   8010055f <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104d66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d6c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d72:	85 c0                	test   %eax,%eax
80104d74:	75 15                	jne    80104d8b <popcli+0x70>
80104d76:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d7c:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d82:	85 c0                	test   %eax,%eax
80104d84:	74 05                	je     80104d8b <popcli+0x70>
    sti();
80104d86:	e8 b0 fd ff ff       	call   80104b3b <sti>
}
80104d8b:	c9                   	leave  
80104d8c:	c3                   	ret    
80104d8d:	00 00                	add    %al,(%eax)
	...

80104d90 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104d95:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d98:	8b 55 10             	mov    0x10(%ebp),%edx
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9e:	89 cb                	mov    %ecx,%ebx
80104da0:	89 df                	mov    %ebx,%edi
80104da2:	89 d1                	mov    %edx,%ecx
80104da4:	fc                   	cld    
80104da5:	f3 aa                	rep stos %al,%es:(%edi)
80104da7:	89 ca                	mov    %ecx,%edx
80104da9:	89 fb                	mov    %edi,%ebx
80104dab:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104dae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104db1:	5b                   	pop    %ebx
80104db2:	5f                   	pop    %edi
80104db3:	c9                   	leave  
80104db4:	c3                   	ret    

80104db5 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80104db5:	55                   	push   %ebp
80104db6:	89 e5                	mov    %esp,%ebp
80104db8:	57                   	push   %edi
80104db9:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104dba:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dbd:	8b 55 10             	mov    0x10(%ebp),%edx
80104dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dc3:	89 cb                	mov    %ecx,%ebx
80104dc5:	89 df                	mov    %ebx,%edi
80104dc7:	89 d1                	mov    %edx,%ecx
80104dc9:	fc                   	cld    
80104dca:	f3 ab                	rep stos %eax,%es:(%edi)
80104dcc:	89 ca                	mov    %ecx,%edx
80104dce:	89 fb                	mov    %edi,%ebx
80104dd0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104dd3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80104dd6:	5b                   	pop    %ebx
80104dd7:	5f                   	pop    %edi
80104dd8:	c9                   	leave  
80104dd9:	c3                   	ret    

80104dda <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104dda:	55                   	push   %ebp
80104ddb:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80104ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80104de0:	83 e0 03             	and    $0x3,%eax
80104de3:	85 c0                	test   %eax,%eax
80104de5:	75 43                	jne    80104e2a <memset+0x50>
80104de7:	8b 45 10             	mov    0x10(%ebp),%eax
80104dea:	83 e0 03             	and    $0x3,%eax
80104ded:	85 c0                	test   %eax,%eax
80104def:	75 39                	jne    80104e2a <memset+0x50>
    c &= 0xFF;
80104df1:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104df8:	8b 45 10             	mov    0x10(%ebp),%eax
80104dfb:	c1 e8 02             	shr    $0x2,%eax
80104dfe:	89 c2                	mov    %eax,%edx
80104e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e03:	89 c1                	mov    %eax,%ecx
80104e05:	c1 e1 18             	shl    $0x18,%ecx
80104e08:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e0b:	c1 e0 10             	shl    $0x10,%eax
80104e0e:	09 c1                	or     %eax,%ecx
80104e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e13:	c1 e0 08             	shl    $0x8,%eax
80104e16:	09 c8                	or     %ecx,%eax
80104e18:	0b 45 0c             	or     0xc(%ebp),%eax
80104e1b:	52                   	push   %edx
80104e1c:	50                   	push   %eax
80104e1d:	ff 75 08             	pushl  0x8(%ebp)
80104e20:	e8 90 ff ff ff       	call   80104db5 <stosl>
80104e25:	83 c4 0c             	add    $0xc,%esp
80104e28:	eb 12                	jmp    80104e3c <memset+0x62>
  } else
    stosb(dst, c, n);
80104e2a:	8b 45 10             	mov    0x10(%ebp),%eax
80104e2d:	50                   	push   %eax
80104e2e:	ff 75 0c             	pushl  0xc(%ebp)
80104e31:	ff 75 08             	pushl  0x8(%ebp)
80104e34:	e8 57 ff ff ff       	call   80104d90 <stosb>
80104e39:	83 c4 0c             	add    $0xc,%esp
  return dst;
80104e3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e3f:	c9                   	leave  
80104e40:	c3                   	ret    

80104e41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e41:	55                   	push   %ebp
80104e42:	89 e5                	mov    %esp,%ebp
80104e44:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104e47:	8b 45 08             	mov    0x8(%ebp),%eax
80104e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104e53:	eb 2c                	jmp    80104e81 <memcmp+0x40>
    if(*s1 != *s2)
80104e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e58:	8a 10                	mov    (%eax),%dl
80104e5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e5d:	8a 00                	mov    (%eax),%al
80104e5f:	38 c2                	cmp    %al,%dl
80104e61:	74 18                	je     80104e7b <memcmp+0x3a>
      return *s1 - *s2;
80104e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e66:	8a 00                	mov    (%eax),%al
80104e68:	0f b6 d0             	movzbl %al,%edx
80104e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e6e:	8a 00                	mov    (%eax),%al
80104e70:	0f b6 c0             	movzbl %al,%eax
80104e73:	89 d1                	mov    %edx,%ecx
80104e75:	29 c1                	sub    %eax,%ecx
80104e77:	89 c8                	mov    %ecx,%eax
80104e79:	eb 19                	jmp    80104e94 <memcmp+0x53>
    s1++, s2++;
80104e7b:	ff 45 fc             	incl   -0x4(%ebp)
80104e7e:	ff 45 f8             	incl   -0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e85:	0f 95 c0             	setne  %al
80104e88:	ff 4d 10             	decl   0x10(%ebp)
80104e8b:	84 c0                	test   %al,%al
80104e8d:	75 c6                	jne    80104e55 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e94:	c9                   	leave  
80104e95:	c3                   	ret    

80104e96 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e96:	55                   	push   %ebp
80104e97:	89 e5                	mov    %esp,%ebp
80104e99:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104eae:	73 4e                	jae    80104efe <memmove+0x68>
80104eb0:	8b 45 10             	mov    0x10(%ebp),%eax
80104eb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104eb6:	8d 04 02             	lea    (%edx,%eax,1),%eax
80104eb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104ebc:	76 43                	jbe    80104f01 <memmove+0x6b>
    s += n;
80104ebe:	8b 45 10             	mov    0x10(%ebp),%eax
80104ec1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104ec4:	8b 45 10             	mov    0x10(%ebp),%eax
80104ec7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104eca:	eb 10                	jmp    80104edc <memmove+0x46>
      *--d = *--s;
80104ecc:	ff 4d f8             	decl   -0x8(%ebp)
80104ecf:	ff 4d fc             	decl   -0x4(%ebp)
80104ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ed5:	8a 10                	mov    (%eax),%dl
80104ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104eda:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ee0:	0f 95 c0             	setne  %al
80104ee3:	ff 4d 10             	decl   0x10(%ebp)
80104ee6:	84 c0                	test   %al,%al
80104ee8:	75 e2                	jne    80104ecc <memmove+0x36>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104eea:	eb 24                	jmp    80104f10 <memmove+0x7a>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80104eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104eef:	8a 10                	mov    (%eax),%dl
80104ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104ef4:	88 10                	mov    %dl,(%eax)
80104ef6:	ff 45 f8             	incl   -0x8(%ebp)
80104ef9:	ff 45 fc             	incl   -0x4(%ebp)
80104efc:	eb 04                	jmp    80104f02 <memmove+0x6c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104efe:	90                   	nop
80104eff:	eb 01                	jmp    80104f02 <memmove+0x6c>
80104f01:	90                   	nop
80104f02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f06:	0f 95 c0             	setne  %al
80104f09:	ff 4d 10             	decl   0x10(%ebp)
80104f0c:	84 c0                	test   %al,%al
80104f0e:	75 dc                	jne    80104eec <memmove+0x56>
      *d++ = *s++;

  return dst;
80104f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104f13:	c9                   	leave  
80104f14:	c3                   	ret    

80104f15 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f15:	55                   	push   %ebp
80104f16:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80104f18:	ff 75 10             	pushl  0x10(%ebp)
80104f1b:	ff 75 0c             	pushl  0xc(%ebp)
80104f1e:	ff 75 08             	pushl  0x8(%ebp)
80104f21:	e8 70 ff ff ff       	call   80104e96 <memmove>
80104f26:	83 c4 0c             	add    $0xc,%esp
}
80104f29:	c9                   	leave  
80104f2a:	c3                   	ret    

80104f2b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104f2b:	55                   	push   %ebp
80104f2c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104f2e:	eb 09                	jmp    80104f39 <strncmp+0xe>
    n--, p++, q++;
80104f30:	ff 4d 10             	decl   0x10(%ebp)
80104f33:	ff 45 08             	incl   0x8(%ebp)
80104f36:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104f39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f3d:	74 17                	je     80104f56 <strncmp+0x2b>
80104f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80104f42:	8a 00                	mov    (%eax),%al
80104f44:	84 c0                	test   %al,%al
80104f46:	74 0e                	je     80104f56 <strncmp+0x2b>
80104f48:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4b:	8a 10                	mov    (%eax),%dl
80104f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f50:	8a 00                	mov    (%eax),%al
80104f52:	38 c2                	cmp    %al,%dl
80104f54:	74 da                	je     80104f30 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80104f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f5a:	75 07                	jne    80104f63 <strncmp+0x38>
    return 0;
80104f5c:	b8 00 00 00 00       	mov    $0x0,%eax
80104f61:	eb 16                	jmp    80104f79 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80104f63:	8b 45 08             	mov    0x8(%ebp),%eax
80104f66:	8a 00                	mov    (%eax),%al
80104f68:	0f b6 d0             	movzbl %al,%edx
80104f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6e:	8a 00                	mov    (%eax),%al
80104f70:	0f b6 c0             	movzbl %al,%eax
80104f73:	89 d1                	mov    %edx,%ecx
80104f75:	29 c1                	sub    %eax,%ecx
80104f77:	89 c8                	mov    %ecx,%eax
}
80104f79:	c9                   	leave  
80104f7a:	c3                   	ret    

80104f7b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f7b:	55                   	push   %ebp
80104f7c:	89 e5                	mov    %esp,%ebp
80104f7e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f81:	8b 45 08             	mov    0x8(%ebp),%eax
80104f84:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f87:	90                   	nop
80104f88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f8c:	0f 9f c0             	setg   %al
80104f8f:	ff 4d 10             	decl   0x10(%ebp)
80104f92:	84 c0                	test   %al,%al
80104f94:	74 2b                	je     80104fc1 <strncpy+0x46>
80104f96:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f99:	8a 10                	mov    (%eax),%dl
80104f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9e:	88 10                	mov    %dl,(%eax)
80104fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa3:	8a 00                	mov    (%eax),%al
80104fa5:	84 c0                	test   %al,%al
80104fa7:	0f 95 c0             	setne  %al
80104faa:	ff 45 08             	incl   0x8(%ebp)
80104fad:	ff 45 0c             	incl   0xc(%ebp)
80104fb0:	84 c0                	test   %al,%al
80104fb2:	75 d4                	jne    80104f88 <strncpy+0xd>
    ;
  while(n-- > 0)
80104fb4:	eb 0c                	jmp    80104fc2 <strncpy+0x47>
    *s++ = 0;
80104fb6:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb9:	c6 00 00             	movb   $0x0,(%eax)
80104fbc:	ff 45 08             	incl   0x8(%ebp)
80104fbf:	eb 01                	jmp    80104fc2 <strncpy+0x47>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104fc1:	90                   	nop
80104fc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fc6:	0f 9f c0             	setg   %al
80104fc9:	ff 4d 10             	decl   0x10(%ebp)
80104fcc:	84 c0                	test   %al,%al
80104fce:	75 e6                	jne    80104fb6 <strncpy+0x3b>
    *s++ = 0;
  return os;
80104fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104fd3:	c9                   	leave  
80104fd4:	c3                   	ret    

80104fd5 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fd5:	55                   	push   %ebp
80104fd6:	89 e5                	mov    %esp,%ebp
80104fd8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fde:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104fe5:	7f 05                	jg     80104fec <safestrcpy+0x17>
    return os;
80104fe7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fea:	eb 30                	jmp    8010501c <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80104fec:	ff 4d 10             	decl   0x10(%ebp)
80104fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ff3:	7e 1e                	jle    80105013 <safestrcpy+0x3e>
80104ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff8:	8a 10                	mov    (%eax),%dl
80104ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80104ffd:	88 10                	mov    %dl,(%eax)
80104fff:	8b 45 08             	mov    0x8(%ebp),%eax
80105002:	8a 00                	mov    (%eax),%al
80105004:	84 c0                	test   %al,%al
80105006:	0f 95 c0             	setne  %al
80105009:	ff 45 08             	incl   0x8(%ebp)
8010500c:	ff 45 0c             	incl   0xc(%ebp)
8010500f:	84 c0                	test   %al,%al
80105011:	75 d9                	jne    80104fec <safestrcpy+0x17>
    ;
  *s = 0;
80105013:	8b 45 08             	mov    0x8(%ebp),%eax
80105016:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105019:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010501c:	c9                   	leave  
8010501d:	c3                   	ret    

8010501e <strlen>:

int
strlen(const char *s)
{
8010501e:	55                   	push   %ebp
8010501f:	89 e5                	mov    %esp,%ebp
80105021:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010502b:	eb 03                	jmp    80105030 <strlen+0x12>
8010502d:	ff 45 fc             	incl   -0x4(%ebp)
80105030:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105033:	03 45 08             	add    0x8(%ebp),%eax
80105036:	8a 00                	mov    (%eax),%al
80105038:	84 c0                	test   %al,%al
8010503a:	75 f1                	jne    8010502d <strlen+0xf>
    ;
  return n;
8010503c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010503f:	c9                   	leave  
80105040:	c3                   	ret    
80105041:	00 00                	add    %al,(%eax)
	...

80105044 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105044:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105048:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010504c:	55                   	push   %ebp
  pushl %ebx
8010504d:	53                   	push   %ebx
  pushl %esi
8010504e:	56                   	push   %esi
  pushl %edi
8010504f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105050:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105052:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105054:	5f                   	pop    %edi
  popl %esi
80105055:	5e                   	pop    %esi
  popl %ebx
80105056:	5b                   	pop    %ebx
  popl %ebp
80105057:	5d                   	pop    %ebp
  ret
80105058:	c3                   	ret    
80105059:	00 00                	add    %al,(%eax)
	...

8010505c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010505c:	55                   	push   %ebp
8010505d:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010505f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105065:	8b 00                	mov    (%eax),%eax
80105067:	3b 45 08             	cmp    0x8(%ebp),%eax
8010506a:	76 12                	jbe    8010507e <fetchint+0x22>
8010506c:	8b 45 08             	mov    0x8(%ebp),%eax
8010506f:	8d 50 04             	lea    0x4(%eax),%edx
80105072:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105078:	8b 00                	mov    (%eax),%eax
8010507a:	39 c2                	cmp    %eax,%edx
8010507c:	76 07                	jbe    80105085 <fetchint+0x29>
    return -1;
8010507e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105083:	eb 0f                	jmp    80105094 <fetchint+0x38>
  *ip = *(int*)(addr);
80105085:	8b 45 08             	mov    0x8(%ebp),%eax
80105088:	8b 10                	mov    (%eax),%edx
8010508a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508d:	89 10                	mov    %edx,(%eax)
  return 0;
8010508f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105094:	c9                   	leave  
80105095:	c3                   	ret    

80105096 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105096:	55                   	push   %ebp
80105097:	89 e5                	mov    %esp,%ebp
80105099:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010509c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a2:	8b 00                	mov    (%eax),%eax
801050a4:	3b 45 08             	cmp    0x8(%ebp),%eax
801050a7:	77 07                	ja     801050b0 <fetchstr+0x1a>
    return -1;
801050a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ae:	eb 46                	jmp    801050f6 <fetchstr+0x60>
  *pp = (char*)addr;
801050b0:	8b 55 08             	mov    0x8(%ebp),%edx
801050b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801050b6:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801050b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050be:	8b 00                	mov    (%eax),%eax
801050c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801050c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c6:	8b 00                	mov    (%eax),%eax
801050c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801050cb:	eb 1c                	jmp    801050e9 <fetchstr+0x53>
    if(*s == 0)
801050cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d0:	8a 00                	mov    (%eax),%al
801050d2:	84 c0                	test   %al,%al
801050d4:	75 10                	jne    801050e6 <fetchstr+0x50>
      return s - *pp;
801050d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050dc:	8b 00                	mov    (%eax),%eax
801050de:	89 d1                	mov    %edx,%ecx
801050e0:	29 c1                	sub    %eax,%ecx
801050e2:	89 c8                	mov    %ecx,%eax
801050e4:	eb 10                	jmp    801050f6 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801050e6:	ff 45 fc             	incl   -0x4(%ebp)
801050e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050ef:	72 dc                	jb     801050cd <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f6:	c9                   	leave  
801050f7:	c3                   	ret    

801050f8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050f8:	55                   	push   %ebp
801050f9:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801050fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105101:	8b 40 18             	mov    0x18(%eax),%eax
80105104:	8b 50 44             	mov    0x44(%eax),%edx
80105107:	8b 45 08             	mov    0x8(%ebp),%eax
8010510a:	c1 e0 02             	shl    $0x2,%eax
8010510d:	8d 04 02             	lea    (%edx,%eax,1),%eax
80105110:	83 c0 04             	add    $0x4,%eax
80105113:	ff 75 0c             	pushl  0xc(%ebp)
80105116:	50                   	push   %eax
80105117:	e8 40 ff ff ff       	call   8010505c <fetchint>
8010511c:	83 c4 08             	add    $0x8,%esp
}
8010511f:	c9                   	leave  
80105120:	c3                   	ret    

80105121 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105121:	55                   	push   %ebp
80105122:	89 e5                	mov    %esp,%ebp
80105124:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105127:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010512a:	50                   	push   %eax
8010512b:	ff 75 08             	pushl  0x8(%ebp)
8010512e:	e8 c5 ff ff ff       	call   801050f8 <argint>
80105133:	83 c4 08             	add    $0x8,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	79 07                	jns    80105141 <argptr+0x20>
    return -1;
8010513a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513f:	eb 3d                	jmp    8010517e <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105141:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105144:	89 c2                	mov    %eax,%edx
80105146:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514c:	8b 00                	mov    (%eax),%eax
8010514e:	39 c2                	cmp    %eax,%edx
80105150:	73 16                	jae    80105168 <argptr+0x47>
80105152:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105155:	89 c2                	mov    %eax,%edx
80105157:	8b 45 10             	mov    0x10(%ebp),%eax
8010515a:	01 c2                	add    %eax,%edx
8010515c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105162:	8b 00                	mov    (%eax),%eax
80105164:	39 c2                	cmp    %eax,%edx
80105166:	76 07                	jbe    8010516f <argptr+0x4e>
    return -1;
80105168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516d:	eb 0f                	jmp    8010517e <argptr+0x5d>
  *pp = (char*)i;
8010516f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105172:	89 c2                	mov    %eax,%edx
80105174:	8b 45 0c             	mov    0xc(%ebp),%eax
80105177:	89 10                	mov    %edx,(%eax)
  return 0;
80105179:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010517e:	c9                   	leave  
8010517f:	c3                   	ret    

80105180 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105186:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105189:	50                   	push   %eax
8010518a:	ff 75 08             	pushl  0x8(%ebp)
8010518d:	e8 66 ff ff ff       	call   801050f8 <argint>
80105192:	83 c4 08             	add    $0x8,%esp
80105195:	85 c0                	test   %eax,%eax
80105197:	79 07                	jns    801051a0 <argstr+0x20>
    return -1;
80105199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519e:	eb 0f                	jmp    801051af <argstr+0x2f>
  return fetchstr(addr, pp);
801051a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051a3:	ff 75 0c             	pushl  0xc(%ebp)
801051a6:	50                   	push   %eax
801051a7:	e8 ea fe ff ff       	call   80105096 <fetchstr>
801051ac:	83 c4 08             	add    $0x8,%esp
}
801051af:	c9                   	leave  
801051b0:	c3                   	ret    

801051b1 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801051b1:	55                   	push   %ebp
801051b2:	89 e5                	mov    %esp,%ebp
801051b4:	53                   	push   %ebx
801051b5:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801051b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051be:	8b 40 18             	mov    0x18(%eax),%eax
801051c1:	8b 40 1c             	mov    0x1c(%eax),%eax
801051c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801051c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051cb:	7e 30                	jle    801051fd <syscall+0x4c>
801051cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d0:	83 f8 15             	cmp    $0x15,%eax
801051d3:	77 28                	ja     801051fd <syscall+0x4c>
801051d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d8:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801051df:	85 c0                	test   %eax,%eax
801051e1:	74 1a                	je     801051fd <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801051e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051e9:	8b 58 18             	mov    0x18(%eax),%ebx
801051ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ef:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801051f6:	ff d0                	call   *%eax
801051f8:	89 43 1c             	mov    %eax,0x1c(%ebx)
801051fb:	eb 34                	jmp    80105231 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801051fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105203:	8d 50 6c             	lea    0x6c(%eax),%edx
            proc->pid, proc->name, num);
80105206:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010520c:	8b 40 10             	mov    0x10(%eax),%eax
8010520f:	ff 75 f4             	pushl  -0xc(%ebp)
80105212:	52                   	push   %edx
80105213:	50                   	push   %eax
80105214:	68 a7 83 10 80       	push   $0x801083a7
80105219:	e8 a2 b1 ff ff       	call   801003c0 <cprintf>
8010521e:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105221:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105227:	8b 40 18             	mov    0x18(%eax),%eax
8010522a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105231:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105234:	c9                   	leave  
80105235:	c3                   	ret    
	...

80105238 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105238:	55                   	push   %ebp
80105239:	89 e5                	mov    %esp,%ebp
8010523b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010523e:	83 ec 08             	sub    $0x8,%esp
80105241:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105244:	50                   	push   %eax
80105245:	ff 75 08             	pushl  0x8(%ebp)
80105248:	e8 ab fe ff ff       	call   801050f8 <argint>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	79 07                	jns    8010525b <argfd+0x23>
    return -1;
80105254:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105259:	eb 50                	jmp    801052ab <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010525b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525e:	85 c0                	test   %eax,%eax
80105260:	78 21                	js     80105283 <argfd+0x4b>
80105262:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105265:	83 f8 0f             	cmp    $0xf,%eax
80105268:	7f 19                	jg     80105283 <argfd+0x4b>
8010526a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105270:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105273:	83 c2 08             	add    $0x8,%edx
80105276:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010527a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010527d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105281:	75 07                	jne    8010528a <argfd+0x52>
    return -1;
80105283:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105288:	eb 21                	jmp    801052ab <argfd+0x73>
  if(pfd)
8010528a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010528e:	74 08                	je     80105298 <argfd+0x60>
    *pfd = fd;
80105290:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105293:	8b 45 0c             	mov    0xc(%ebp),%eax
80105296:	89 10                	mov    %edx,(%eax)
  if(pf)
80105298:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010529c:	74 08                	je     801052a6 <argfd+0x6e>
    *pf = f;
8010529e:	8b 45 10             	mov    0x10(%ebp),%eax
801052a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052a4:	89 10                	mov    %edx,(%eax)
  return 0;
801052a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052ab:	c9                   	leave  
801052ac:	c3                   	ret    

801052ad <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801052ad:	55                   	push   %ebp
801052ae:	89 e5                	mov    %esp,%ebp
801052b0:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801052ba:	eb 2f                	jmp    801052eb <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
801052bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052c5:	83 c2 08             	add    $0x8,%edx
801052c8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801052cc:	85 c0                	test   %eax,%eax
801052ce:	75 18                	jne    801052e8 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801052d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052d9:	8d 4a 08             	lea    0x8(%edx),%ecx
801052dc:	8b 55 08             	mov    0x8(%ebp),%edx
801052df:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801052e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e6:	eb 0e                	jmp    801052f6 <fdalloc+0x49>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801052e8:	ff 45 fc             	incl   -0x4(%ebp)
801052eb:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801052ef:	7e cb                	jle    801052bc <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801052f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f6:	c9                   	leave  
801052f7:	c3                   	ret    

801052f8 <sys_dup>:

int
sys_dup(void)
{
801052f8:	55                   	push   %ebp
801052f9:	89 e5                	mov    %esp,%ebp
801052fb:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801052fe:	83 ec 04             	sub    $0x4,%esp
80105301:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105304:	50                   	push   %eax
80105305:	6a 00                	push   $0x0
80105307:	6a 00                	push   $0x0
80105309:	e8 2a ff ff ff       	call   80105238 <argfd>
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	85 c0                	test   %eax,%eax
80105313:	79 07                	jns    8010531c <sys_dup+0x24>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb 31                	jmp    8010534d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010531c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010531f:	83 ec 0c             	sub    $0xc,%esp
80105322:	50                   	push   %eax
80105323:	e8 85 ff ff ff       	call   801052ad <fdalloc>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010532e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105332:	79 07                	jns    8010533b <sys_dup+0x43>
    return -1;
80105334:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105339:	eb 12                	jmp    8010534d <sys_dup+0x55>
  filedup(f);
8010533b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010533e:	83 ec 0c             	sub    $0xc,%esp
80105341:	50                   	push   %eax
80105342:	e8 47 bc ff ff       	call   80100f8e <filedup>
80105347:	83 c4 10             	add    $0x10,%esp
  return fd;
8010534a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010534d:	c9                   	leave  
8010534e:	c3                   	ret    

8010534f <sys_read>:

int
sys_read(void)
{
8010534f:	55                   	push   %ebp
80105350:	89 e5                	mov    %esp,%ebp
80105352:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105355:	83 ec 04             	sub    $0x4,%esp
80105358:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535b:	50                   	push   %eax
8010535c:	6a 00                	push   $0x0
8010535e:	6a 00                	push   $0x0
80105360:	e8 d3 fe ff ff       	call   80105238 <argfd>
80105365:	83 c4 10             	add    $0x10,%esp
80105368:	85 c0                	test   %eax,%eax
8010536a:	78 2e                	js     8010539a <sys_read+0x4b>
8010536c:	83 ec 08             	sub    $0x8,%esp
8010536f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105372:	50                   	push   %eax
80105373:	6a 02                	push   $0x2
80105375:	e8 7e fd ff ff       	call   801050f8 <argint>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 19                	js     8010539a <sys_read+0x4b>
80105381:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105384:	83 ec 04             	sub    $0x4,%esp
80105387:	50                   	push   %eax
80105388:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010538b:	50                   	push   %eax
8010538c:	6a 01                	push   $0x1
8010538e:	e8 8e fd ff ff       	call   80105121 <argptr>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	79 07                	jns    801053a1 <sys_read+0x52>
    return -1;
8010539a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539f:	eb 17                	jmp    801053b8 <sys_read+0x69>
  return fileread(f, p, n);
801053a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801053a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
801053a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053aa:	83 ec 04             	sub    $0x4,%esp
801053ad:	51                   	push   %ecx
801053ae:	52                   	push   %edx
801053af:	50                   	push   %eax
801053b0:	e8 60 bd ff ff       	call   80101115 <fileread>
801053b5:	83 c4 10             	add    $0x10,%esp
}
801053b8:	c9                   	leave  
801053b9:	c3                   	ret    

801053ba <sys_write>:

int
sys_write(void)
{
801053ba:	55                   	push   %ebp
801053bb:	89 e5                	mov    %esp,%ebp
801053bd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c0:	83 ec 04             	sub    $0x4,%esp
801053c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c6:	50                   	push   %eax
801053c7:	6a 00                	push   $0x0
801053c9:	6a 00                	push   $0x0
801053cb:	e8 68 fe ff ff       	call   80105238 <argfd>
801053d0:	83 c4 10             	add    $0x10,%esp
801053d3:	85 c0                	test   %eax,%eax
801053d5:	78 2e                	js     80105405 <sys_write+0x4b>
801053d7:	83 ec 08             	sub    $0x8,%esp
801053da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053dd:	50                   	push   %eax
801053de:	6a 02                	push   $0x2
801053e0:	e8 13 fd ff ff       	call   801050f8 <argint>
801053e5:	83 c4 10             	add    $0x10,%esp
801053e8:	85 c0                	test   %eax,%eax
801053ea:	78 19                	js     80105405 <sys_write+0x4b>
801053ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ef:	83 ec 04             	sub    $0x4,%esp
801053f2:	50                   	push   %eax
801053f3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053f6:	50                   	push   %eax
801053f7:	6a 01                	push   $0x1
801053f9:	e8 23 fd ff ff       	call   80105121 <argptr>
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	79 07                	jns    8010540c <sys_write+0x52>
    return -1;
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540a:	eb 17                	jmp    80105423 <sys_write+0x69>
  return filewrite(f, p, n);
8010540c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010540f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105412:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105415:	83 ec 04             	sub    $0x4,%esp
80105418:	51                   	push   %ecx
80105419:	52                   	push   %edx
8010541a:	50                   	push   %eax
8010541b:	e8 ac bd ff ff       	call   801011cc <filewrite>
80105420:	83 c4 10             	add    $0x10,%esp
}
80105423:	c9                   	leave  
80105424:	c3                   	ret    

80105425 <sys_close>:

int
sys_close(void)
{
80105425:	55                   	push   %ebp
80105426:	89 e5                	mov    %esp,%ebp
80105428:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010542b:	83 ec 04             	sub    $0x4,%esp
8010542e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105431:	50                   	push   %eax
80105432:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105435:	50                   	push   %eax
80105436:	6a 00                	push   $0x0
80105438:	e8 fb fd ff ff       	call   80105238 <argfd>
8010543d:	83 c4 10             	add    $0x10,%esp
80105440:	85 c0                	test   %eax,%eax
80105442:	79 07                	jns    8010544b <sys_close+0x26>
    return -1;
80105444:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105449:	eb 28                	jmp    80105473 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010544b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105451:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105454:	83 c2 08             	add    $0x8,%edx
80105457:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010545e:	00 
  fileclose(f);
8010545f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	50                   	push   %eax
80105466:	e8 74 bb ff ff       	call   80100fdf <fileclose>
8010546b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010546e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105473:	c9                   	leave  
80105474:	c3                   	ret    

80105475 <sys_fstat>:

int
sys_fstat(void)
{
80105475:	55                   	push   %ebp
80105476:	89 e5                	mov    %esp,%ebp
80105478:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010547b:	83 ec 04             	sub    $0x4,%esp
8010547e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	6a 00                	push   $0x0
80105486:	e8 ad fd ff ff       	call   80105238 <argfd>
8010548b:	83 c4 10             	add    $0x10,%esp
8010548e:	85 c0                	test   %eax,%eax
80105490:	78 17                	js     801054a9 <sys_fstat+0x34>
80105492:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105495:	83 ec 04             	sub    $0x4,%esp
80105498:	6a 14                	push   $0x14
8010549a:	50                   	push   %eax
8010549b:	6a 01                	push   $0x1
8010549d:	e8 7f fc ff ff       	call   80105121 <argptr>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	79 07                	jns    801054b0 <sys_fstat+0x3b>
    return -1;
801054a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ae:	eb 13                	jmp    801054c3 <sys_fstat+0x4e>
  return filestat(f, st);
801054b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b6:	83 ec 08             	sub    $0x8,%esp
801054b9:	52                   	push   %edx
801054ba:	50                   	push   %eax
801054bb:	e8 fe bb ff ff       	call   801010be <filestat>
801054c0:	83 c4 10             	add    $0x10,%esp
}
801054c3:	c9                   	leave  
801054c4:	c3                   	ret    

801054c5 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801054c5:	55                   	push   %ebp
801054c6:	89 e5                	mov    %esp,%ebp
801054c8:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054cb:	83 ec 08             	sub    $0x8,%esp
801054ce:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054d1:	50                   	push   %eax
801054d2:	6a 00                	push   $0x0
801054d4:	e8 a7 fc ff ff       	call   80105180 <argstr>
801054d9:	83 c4 10             	add    $0x10,%esp
801054dc:	85 c0                	test   %eax,%eax
801054de:	78 15                	js     801054f5 <sys_link+0x30>
801054e0:	83 ec 08             	sub    $0x8,%esp
801054e3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801054e6:	50                   	push   %eax
801054e7:	6a 01                	push   $0x1
801054e9:	e8 92 fc ff ff       	call   80105180 <argstr>
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	85 c0                	test   %eax,%eax
801054f3:	79 0a                	jns    801054ff <sys_link+0x3a>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fa:	e9 5a 01 00 00       	jmp    80105659 <sys_link+0x194>
  if((ip = namei(old)) == 0)
801054ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105502:	83 ec 0c             	sub    $0xc,%esp
80105505:	50                   	push   %eax
80105506:	e8 3b cf ff ff       	call   80102446 <namei>
8010550b:	83 c4 10             	add    $0x10,%esp
8010550e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105515:	75 0a                	jne    80105521 <sys_link+0x5c>
    return -1;
80105517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551c:	e9 38 01 00 00       	jmp    80105659 <sys_link+0x194>

  begin_trans();
80105521:	e8 e5 dc ff ff       	call   8010320b <begin_trans>

  ilock(ip);
80105526:	83 ec 0c             	sub    $0xc,%esp
80105529:	ff 75 f4             	pushl  -0xc(%ebp)
8010552c:	e8 79 c3 ff ff       	call   801018aa <ilock>
80105531:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105537:	8b 40 10             	mov    0x10(%eax),%eax
8010553a:	66 83 f8 01          	cmp    $0x1,%ax
8010553e:	75 1d                	jne    8010555d <sys_link+0x98>
    iunlockput(ip);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	ff 75 f4             	pushl  -0xc(%ebp)
80105546:	e8 16 c6 ff ff       	call   80101b61 <iunlockput>
8010554b:	83 c4 10             	add    $0x10,%esp
    commit_trans();
8010554e:	e8 0a dd ff ff       	call   8010325d <commit_trans>
    return -1;
80105553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105558:	e9 fc 00 00 00       	jmp    80105659 <sys_link+0x194>
  }

  ip->nlink++;
8010555d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105560:	66 8b 40 16          	mov    0x16(%eax),%ax
80105564:	40                   	inc    %eax
80105565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105568:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	ff 75 f4             	pushl  -0xc(%ebp)
80105572:	e8 5e c1 ff ff       	call   801016d5 <iupdate>
80105577:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	ff 75 f4             	pushl  -0xc(%ebp)
80105580:	e8 7c c4 ff ff       	call   80101a01 <iunlock>
80105585:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105588:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105591:	52                   	push   %edx
80105592:	50                   	push   %eax
80105593:	e8 ca ce ff ff       	call   80102462 <nameiparent>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010559e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055a2:	74 71                	je     80105615 <sys_link+0x150>
    goto bad;
  ilock(dp);
801055a4:	83 ec 0c             	sub    $0xc,%esp
801055a7:	ff 75 f0             	pushl  -0x10(%ebp)
801055aa:	e8 fb c2 ff ff       	call   801018aa <ilock>
801055af:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b5:	8b 10                	mov    (%eax),%edx
801055b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ba:	8b 00                	mov    (%eax),%eax
801055bc:	39 c2                	cmp    %eax,%edx
801055be:	75 1d                	jne    801055dd <sys_link+0x118>
801055c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c3:	8b 40 04             	mov    0x4(%eax),%eax
801055c6:	83 ec 04             	sub    $0x4,%esp
801055c9:	50                   	push   %eax
801055ca:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801055cd:	50                   	push   %eax
801055ce:	ff 75 f0             	pushl  -0x10(%ebp)
801055d1:	e8 e0 cb ff ff       	call   801021b6 <dirlink>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	79 10                	jns    801055ed <sys_link+0x128>
    iunlockput(dp);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	ff 75 f0             	pushl  -0x10(%ebp)
801055e3:	e8 79 c5 ff ff       	call   80101b61 <iunlockput>
801055e8:	83 c4 10             	add    $0x10,%esp
    goto bad;
801055eb:	eb 29                	jmp    80105616 <sys_link+0x151>
  }
  iunlockput(dp);
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	ff 75 f0             	pushl  -0x10(%ebp)
801055f3:	e8 69 c5 ff ff       	call   80101b61 <iunlockput>
801055f8:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801055fb:	83 ec 0c             	sub    $0xc,%esp
801055fe:	ff 75 f4             	pushl  -0xc(%ebp)
80105601:	e8 6c c4 ff ff       	call   80101a72 <iput>
80105606:	83 c4 10             	add    $0x10,%esp

  commit_trans();
80105609:	e8 4f dc ff ff       	call   8010325d <commit_trans>

  return 0;
8010560e:	b8 00 00 00 00       	mov    $0x0,%eax
80105613:	eb 44                	jmp    80105659 <sys_link+0x194>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105615:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	ff 75 f4             	pushl  -0xc(%ebp)
8010561c:	e8 89 c2 ff ff       	call   801018aa <ilock>
80105621:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105627:	66 8b 40 16          	mov    0x16(%eax),%ax
8010562b:	48                   	dec    %eax
8010562c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010562f:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	ff 75 f4             	pushl  -0xc(%ebp)
80105639:	e8 97 c0 ff ff       	call   801016d5 <iupdate>
8010563e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105641:	83 ec 0c             	sub    $0xc,%esp
80105644:	ff 75 f4             	pushl  -0xc(%ebp)
80105647:	e8 15 c5 ff ff       	call   80101b61 <iunlockput>
8010564c:	83 c4 10             	add    $0x10,%esp
  commit_trans();
8010564f:	e8 09 dc ff ff       	call   8010325d <commit_trans>
  return -1;
80105654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105659:	c9                   	leave  
8010565a:	c3                   	ret    

8010565b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010565b:	55                   	push   %ebp
8010565c:	89 e5                	mov    %esp,%ebp
8010565e:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105661:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105668:	eb 3f                	jmp    801056a9 <isdirempty+0x4e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010566a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010566d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105670:	6a 10                	push   $0x10
80105672:	52                   	push   %edx
80105673:	50                   	push   %eax
80105674:	ff 75 08             	pushl  0x8(%ebp)
80105677:	e8 76 c7 ff ff       	call   80101df2 <readi>
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	83 f8 10             	cmp    $0x10,%eax
80105682:	74 0d                	je     80105691 <isdirempty+0x36>
      panic("isdirempty: readi");
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	68 c3 83 10 80       	push   $0x801083c3
8010568c:	e8 ce ae ff ff       	call   8010055f <panic>
    if(de.inum != 0)
80105691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105694:	66 85 c0             	test   %ax,%ax
80105697:	74 07                	je     801056a0 <isdirempty+0x45>
      return 0;
80105699:	b8 00 00 00 00       	mov    $0x0,%eax
8010569e:	eb 1b                	jmp    801056bb <isdirempty+0x60>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056a3:	83 c0 10             	add    $0x10,%eax
801056a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056ac:	8b 45 08             	mov    0x8(%ebp),%eax
801056af:	8b 40 18             	mov    0x18(%eax),%eax
801056b2:	39 c2                	cmp    %eax,%edx
801056b4:	72 b4                	jb     8010566a <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801056b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801056bb:	c9                   	leave  
801056bc:	c3                   	ret    

801056bd <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801056bd:	55                   	push   %ebp
801056be:	89 e5                	mov    %esp,%ebp
801056c0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 00                	push   $0x0
801056cc:	e8 af fa ff ff       	call   80105180 <argstr>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	79 0a                	jns    801056e2 <sys_unlink+0x25>
    return -1;
801056d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056dd:	e9 ad 01 00 00       	jmp    8010588f <sys_unlink+0x1d2>
  if((dp = nameiparent(path, name)) == 0)
801056e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801056eb:	52                   	push   %edx
801056ec:	50                   	push   %eax
801056ed:	e8 70 cd ff ff       	call   80102462 <nameiparent>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056fc:	75 0a                	jne    80105708 <sys_unlink+0x4b>
    return -1;
801056fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105703:	e9 87 01 00 00       	jmp    8010588f <sys_unlink+0x1d2>

  begin_trans();
80105708:	e8 fe da ff ff       	call   8010320b <begin_trans>

  ilock(dp);
8010570d:	83 ec 0c             	sub    $0xc,%esp
80105710:	ff 75 f4             	pushl  -0xc(%ebp)
80105713:	e8 92 c1 ff ff       	call   801018aa <ilock>
80105718:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010571b:	83 ec 08             	sub    $0x8,%esp
8010571e:	68 d5 83 10 80       	push   $0x801083d5
80105723:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105726:	50                   	push   %eax
80105727:	e8 b8 c9 ff ff       	call   801020e4 <namecmp>
8010572c:	83 c4 10             	add    $0x10,%esp
8010572f:	85 c0                	test   %eax,%eax
80105731:	0f 84 40 01 00 00    	je     80105877 <sys_unlink+0x1ba>
80105737:	83 ec 08             	sub    $0x8,%esp
8010573a:	68 d7 83 10 80       	push   $0x801083d7
8010573f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105742:	50                   	push   %eax
80105743:	e8 9c c9 ff ff       	call   801020e4 <namecmp>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	85 c0                	test   %eax,%eax
8010574d:	0f 84 24 01 00 00    	je     80105877 <sys_unlink+0x1ba>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105753:	83 ec 04             	sub    $0x4,%esp
80105756:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010575d:	50                   	push   %eax
8010575e:	ff 75 f4             	pushl  -0xc(%ebp)
80105761:	e8 99 c9 ff ff       	call   801020ff <dirlookup>
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010576c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105770:	0f 84 00 01 00 00    	je     80105876 <sys_unlink+0x1b9>
    goto bad;
  ilock(ip);
80105776:	83 ec 0c             	sub    $0xc,%esp
80105779:	ff 75 f0             	pushl  -0x10(%ebp)
8010577c:	e8 29 c1 ff ff       	call   801018aa <ilock>
80105781:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105787:	66 8b 40 16          	mov    0x16(%eax),%ax
8010578b:	66 85 c0             	test   %ax,%ax
8010578e:	7f 0d                	jg     8010579d <sys_unlink+0xe0>
    panic("unlink: nlink < 1");
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 da 83 10 80       	push   $0x801083da
80105798:	e8 c2 ad ff ff       	call   8010055f <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010579d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a0:	8b 40 10             	mov    0x10(%eax),%eax
801057a3:	66 83 f8 01          	cmp    $0x1,%ax
801057a7:	75 25                	jne    801057ce <sys_unlink+0x111>
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	ff 75 f0             	pushl  -0x10(%ebp)
801057af:	e8 a7 fe ff ff       	call   8010565b <isdirempty>
801057b4:	83 c4 10             	add    $0x10,%esp
801057b7:	85 c0                	test   %eax,%eax
801057b9:	75 13                	jne    801057ce <sys_unlink+0x111>
    iunlockput(ip);
801057bb:	83 ec 0c             	sub    $0xc,%esp
801057be:	ff 75 f0             	pushl  -0x10(%ebp)
801057c1:	e8 9b c3 ff ff       	call   80101b61 <iunlockput>
801057c6:	83 c4 10             	add    $0x10,%esp
    goto bad;
801057c9:	e9 a9 00 00 00       	jmp    80105877 <sys_unlink+0x1ba>
  }

  memset(&de, 0, sizeof(de));
801057ce:	83 ec 04             	sub    $0x4,%esp
801057d1:	6a 10                	push   $0x10
801057d3:	6a 00                	push   $0x0
801057d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057d8:	50                   	push   %eax
801057d9:	e8 fc f5 ff ff       	call   80104dda <memset>
801057de:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057e1:	8b 55 c8             	mov    -0x38(%ebp),%edx
801057e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057e7:	6a 10                	push   $0x10
801057e9:	52                   	push   %edx
801057ea:	50                   	push   %eax
801057eb:	ff 75 f4             	pushl  -0xc(%ebp)
801057ee:	e8 5f c7 ff ff       	call   80101f52 <writei>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	83 f8 10             	cmp    $0x10,%eax
801057f9:	74 0d                	je     80105808 <sys_unlink+0x14b>
    panic("unlink: writei");
801057fb:	83 ec 0c             	sub    $0xc,%esp
801057fe:	68 ec 83 10 80       	push   $0x801083ec
80105803:	e8 57 ad ff ff       	call   8010055f <panic>
  if(ip->type == T_DIR){
80105808:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010580b:	8b 40 10             	mov    0x10(%eax),%eax
8010580e:	66 83 f8 01          	cmp    $0x1,%ax
80105812:	75 1d                	jne    80105831 <sys_unlink+0x174>
    dp->nlink--;
80105814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105817:	66 8b 40 16          	mov    0x16(%eax),%ax
8010581b:	48                   	dec    %eax
8010581c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010581f:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105823:	83 ec 0c             	sub    $0xc,%esp
80105826:	ff 75 f4             	pushl  -0xc(%ebp)
80105829:	e8 a7 be ff ff       	call   801016d5 <iupdate>
8010582e:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	ff 75 f4             	pushl  -0xc(%ebp)
80105837:	e8 25 c3 ff ff       	call   80101b61 <iunlockput>
8010583c:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010583f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105842:	66 8b 40 16          	mov    0x16(%eax),%ax
80105846:	48                   	dec    %eax
80105847:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010584a:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010584e:	83 ec 0c             	sub    $0xc,%esp
80105851:	ff 75 f0             	pushl  -0x10(%ebp)
80105854:	e8 7c be ff ff       	call   801016d5 <iupdate>
80105859:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010585c:	83 ec 0c             	sub    $0xc,%esp
8010585f:	ff 75 f0             	pushl  -0x10(%ebp)
80105862:	e8 fa c2 ff ff       	call   80101b61 <iunlockput>
80105867:	83 c4 10             	add    $0x10,%esp

  commit_trans();
8010586a:	e8 ee d9 ff ff       	call   8010325d <commit_trans>

  return 0;
8010586f:	b8 00 00 00 00       	mov    $0x0,%eax
80105874:	eb 19                	jmp    8010588f <sys_unlink+0x1d2>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105876:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105877:	83 ec 0c             	sub    $0xc,%esp
8010587a:	ff 75 f4             	pushl  -0xc(%ebp)
8010587d:	e8 df c2 ff ff       	call   80101b61 <iunlockput>
80105882:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105885:	e8 d3 d9 ff ff       	call   8010325d <commit_trans>
  return -1;
8010588a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010588f:	c9                   	leave  
80105890:	c3                   	ret    

80105891 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105891:	55                   	push   %ebp
80105892:	89 e5                	mov    %esp,%ebp
80105894:	83 ec 38             	sub    $0x38,%esp
80105897:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010589a:	8b 55 10             	mov    0x10(%ebp),%edx
8010589d:	8b 45 14             	mov    0x14(%ebp),%eax
801058a0:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801058a4:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801058a8:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058ac:	83 ec 08             	sub    $0x8,%esp
801058af:	8d 45 de             	lea    -0x22(%ebp),%eax
801058b2:	50                   	push   %eax
801058b3:	ff 75 08             	pushl  0x8(%ebp)
801058b6:	e8 a7 cb ff ff       	call   80102462 <nameiparent>
801058bb:	83 c4 10             	add    $0x10,%esp
801058be:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058c5:	75 0a                	jne    801058d1 <create+0x40>
    return 0;
801058c7:	b8 00 00 00 00       	mov    $0x0,%eax
801058cc:	e9 89 01 00 00       	jmp    80105a5a <create+0x1c9>
  ilock(dp);
801058d1:	83 ec 0c             	sub    $0xc,%esp
801058d4:	ff 75 f4             	pushl  -0xc(%ebp)
801058d7:	e8 ce bf ff ff       	call   801018aa <ilock>
801058dc:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801058df:	83 ec 04             	sub    $0x4,%esp
801058e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058e5:	50                   	push   %eax
801058e6:	8d 45 de             	lea    -0x22(%ebp),%eax
801058e9:	50                   	push   %eax
801058ea:	ff 75 f4             	pushl  -0xc(%ebp)
801058ed:	e8 0d c8 ff ff       	call   801020ff <dirlookup>
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801058f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801058fc:	74 4f                	je     8010594d <create+0xbc>
    iunlockput(dp);
801058fe:	83 ec 0c             	sub    $0xc,%esp
80105901:	ff 75 f4             	pushl  -0xc(%ebp)
80105904:	e8 58 c2 ff ff       	call   80101b61 <iunlockput>
80105909:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010590c:	83 ec 0c             	sub    $0xc,%esp
8010590f:	ff 75 f0             	pushl  -0x10(%ebp)
80105912:	e8 93 bf ff ff       	call   801018aa <ilock>
80105917:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010591a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010591f:	75 14                	jne    80105935 <create+0xa4>
80105921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105924:	8b 40 10             	mov    0x10(%eax),%eax
80105927:	66 83 f8 02          	cmp    $0x2,%ax
8010592b:	75 08                	jne    80105935 <create+0xa4>
      return ip;
8010592d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105930:	e9 25 01 00 00       	jmp    80105a5a <create+0x1c9>
    iunlockput(ip);
80105935:	83 ec 0c             	sub    $0xc,%esp
80105938:	ff 75 f0             	pushl  -0x10(%ebp)
8010593b:	e8 21 c2 ff ff       	call   80101b61 <iunlockput>
80105940:	83 c4 10             	add    $0x10,%esp
    return 0;
80105943:	b8 00 00 00 00       	mov    $0x0,%eax
80105948:	e9 0d 01 00 00       	jmp    80105a5a <create+0x1c9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010594d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105954:	8b 00                	mov    (%eax),%eax
80105956:	83 ec 08             	sub    $0x8,%esp
80105959:	52                   	push   %edx
8010595a:	50                   	push   %eax
8010595b:	e8 99 bc ff ff       	call   801015f9 <ialloc>
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105966:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010596a:	75 0d                	jne    80105979 <create+0xe8>
    panic("create: ialloc");
8010596c:	83 ec 0c             	sub    $0xc,%esp
8010596f:	68 fb 83 10 80       	push   $0x801083fb
80105974:	e8 e6 ab ff ff       	call   8010055f <panic>

  ilock(ip);
80105979:	83 ec 0c             	sub    $0xc,%esp
8010597c:	ff 75 f0             	pushl  -0x10(%ebp)
8010597f:	e8 26 bf ff ff       	call   801018aa <ilock>
80105984:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105987:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010598a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010598d:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105991:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105994:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105997:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
8010599b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599e:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801059a4:	83 ec 0c             	sub    $0xc,%esp
801059a7:	ff 75 f0             	pushl  -0x10(%ebp)
801059aa:	e8 26 bd ff ff       	call   801016d5 <iupdate>
801059af:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801059b2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801059b7:	75 66                	jne    80105a1f <create+0x18e>
    dp->nlink++;  // for ".."
801059b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bc:	66 8b 40 16          	mov    0x16(%eax),%ax
801059c0:	40                   	inc    %eax
801059c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c4:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	ff 75 f4             	pushl  -0xc(%ebp)
801059ce:	e8 02 bd ff ff       	call   801016d5 <iupdate>
801059d3:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d9:	8b 40 04             	mov    0x4(%eax),%eax
801059dc:	83 ec 04             	sub    $0x4,%esp
801059df:	50                   	push   %eax
801059e0:	68 d5 83 10 80       	push   $0x801083d5
801059e5:	ff 75 f0             	pushl  -0x10(%ebp)
801059e8:	e8 c9 c7 ff ff       	call   801021b6 <dirlink>
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c0                	test   %eax,%eax
801059f2:	78 1e                	js     80105a12 <create+0x181>
801059f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f7:	8b 40 04             	mov    0x4(%eax),%eax
801059fa:	83 ec 04             	sub    $0x4,%esp
801059fd:	50                   	push   %eax
801059fe:	68 d7 83 10 80       	push   $0x801083d7
80105a03:	ff 75 f0             	pushl  -0x10(%ebp)
80105a06:	e8 ab c7 ff ff       	call   801021b6 <dirlink>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	79 0d                	jns    80105a1f <create+0x18e>
      panic("create dots");
80105a12:	83 ec 0c             	sub    $0xc,%esp
80105a15:	68 0a 84 10 80       	push   $0x8010840a
80105a1a:	e8 40 ab ff ff       	call   8010055f <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a22:	8b 40 04             	mov    0x4(%eax),%eax
80105a25:	83 ec 04             	sub    $0x4,%esp
80105a28:	50                   	push   %eax
80105a29:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a2c:	50                   	push   %eax
80105a2d:	ff 75 f4             	pushl  -0xc(%ebp)
80105a30:	e8 81 c7 ff ff       	call   801021b6 <dirlink>
80105a35:	83 c4 10             	add    $0x10,%esp
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	79 0d                	jns    80105a49 <create+0x1b8>
    panic("create: dirlink");
80105a3c:	83 ec 0c             	sub    $0xc,%esp
80105a3f:	68 16 84 10 80       	push   $0x80108416
80105a44:	e8 16 ab ff ff       	call   8010055f <panic>

  iunlockput(dp);
80105a49:	83 ec 0c             	sub    $0xc,%esp
80105a4c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a4f:	e8 0d c1 ff ff       	call   80101b61 <iunlockput>
80105a54:	83 c4 10             	add    $0x10,%esp

  return ip;
80105a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105a5a:	c9                   	leave  
80105a5b:	c3                   	ret    

80105a5c <sys_open>:

int
sys_open(void)
{
80105a5c:	55                   	push   %ebp
80105a5d:	89 e5                	mov    %esp,%ebp
80105a5f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a62:	83 ec 08             	sub    $0x8,%esp
80105a65:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105a68:	50                   	push   %eax
80105a69:	6a 00                	push   $0x0
80105a6b:	e8 10 f7 ff ff       	call   80105180 <argstr>
80105a70:	83 c4 10             	add    $0x10,%esp
80105a73:	85 c0                	test   %eax,%eax
80105a75:	78 15                	js     80105a8c <sys_open+0x30>
80105a77:	83 ec 08             	sub    $0x8,%esp
80105a7a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a7d:	50                   	push   %eax
80105a7e:	6a 01                	push   $0x1
80105a80:	e8 73 f6 ff ff       	call   801050f8 <argint>
80105a85:	83 c4 10             	add    $0x10,%esp
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	79 0a                	jns    80105a96 <sys_open+0x3a>
    return -1;
80105a8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a91:	e9 4a 01 00 00       	jmp    80105be0 <sys_open+0x184>
  if(omode & O_CREATE){
80105a96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a99:	25 00 02 00 00       	and    $0x200,%eax
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	74 2f                	je     80105ad1 <sys_open+0x75>
    begin_trans();
80105aa2:	e8 64 d7 ff ff       	call   8010320b <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105aaa:	6a 00                	push   $0x0
80105aac:	6a 00                	push   $0x0
80105aae:	6a 02                	push   $0x2
80105ab0:	50                   	push   %eax
80105ab1:	e8 db fd ff ff       	call   80105891 <create>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105abc:	e8 9c d7 ff ff       	call   8010325d <commit_trans>
    if(ip == 0)
80105ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ac5:	75 65                	jne    80105b2c <sys_open+0xd0>
      return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	e9 0f 01 00 00       	jmp    80105be0 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ad4:	83 ec 0c             	sub    $0xc,%esp
80105ad7:	50                   	push   %eax
80105ad8:	e8 69 c9 ff ff       	call   80102446 <namei>
80105add:	83 c4 10             	add    $0x10,%esp
80105ae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ae7:	75 0a                	jne    80105af3 <sys_open+0x97>
      return -1;
80105ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aee:	e9 ed 00 00 00       	jmp    80105be0 <sys_open+0x184>
    ilock(ip);
80105af3:	83 ec 0c             	sub    $0xc,%esp
80105af6:	ff 75 f4             	pushl  -0xc(%ebp)
80105af9:	e8 ac bd ff ff       	call   801018aa <ilock>
80105afe:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b04:	8b 40 10             	mov    0x10(%eax),%eax
80105b07:	66 83 f8 01          	cmp    $0x1,%ax
80105b0b:	75 1f                	jne    80105b2c <sys_open+0xd0>
80105b0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b10:	85 c0                	test   %eax,%eax
80105b12:	74 18                	je     80105b2c <sys_open+0xd0>
      iunlockput(ip);
80105b14:	83 ec 0c             	sub    $0xc,%esp
80105b17:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1a:	e8 42 c0 ff ff       	call   80101b61 <iunlockput>
80105b1f:	83 c4 10             	add    $0x10,%esp
      return -1;
80105b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b27:	e9 b4 00 00 00       	jmp    80105be0 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b2c:	e8 f0 b3 ff ff       	call   80100f21 <filealloc>
80105b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b38:	74 17                	je     80105b51 <sys_open+0xf5>
80105b3a:	83 ec 0c             	sub    $0xc,%esp
80105b3d:	ff 75 f0             	pushl  -0x10(%ebp)
80105b40:	e8 68 f7 ff ff       	call   801052ad <fdalloc>
80105b45:	83 c4 10             	add    $0x10,%esp
80105b48:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105b4f:	79 29                	jns    80105b7a <sys_open+0x11e>
    if(f)
80105b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b55:	74 0e                	je     80105b65 <sys_open+0x109>
      fileclose(f);
80105b57:	83 ec 0c             	sub    $0xc,%esp
80105b5a:	ff 75 f0             	pushl  -0x10(%ebp)
80105b5d:	e8 7d b4 ff ff       	call   80100fdf <fileclose>
80105b62:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b65:	83 ec 0c             	sub    $0xc,%esp
80105b68:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6b:	e8 f1 bf ff ff       	call   80101b61 <iunlockput>
80105b70:	83 c4 10             	add    $0x10,%esp
    return -1;
80105b73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b78:	eb 66                	jmp    80105be0 <sys_open+0x184>
  }
  iunlock(ip);
80105b7a:	83 ec 0c             	sub    $0xc,%esp
80105b7d:	ff 75 f4             	pushl  -0xc(%ebp)
80105b80:	e8 7c be ff ff       	call   80101a01 <iunlock>
80105b85:	83 c4 10             	add    $0x10,%esp

  f->type = FD_INODE;
80105b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b8b:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b97:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105ba4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ba7:	83 e0 01             	and    $0x1,%eax
80105baa:	85 c0                	test   %eax,%eax
80105bac:	0f 94 c2             	sete   %dl
80105baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb2:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bb8:	83 e0 01             	and    $0x1,%eax
80105bbb:	84 c0                	test   %al,%al
80105bbd:	75 0a                	jne    80105bc9 <sys_open+0x16d>
80105bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105bc2:	83 e0 02             	and    $0x2,%eax
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 07                	je     80105bd0 <sys_open+0x174>
80105bc9:	b8 01 00 00 00       	mov    $0x1,%eax
80105bce:	eb 05                	jmp    80105bd5 <sys_open+0x179>
80105bd0:	b8 00 00 00 00       	mov    $0x0,%eax
80105bd5:	88 c2                	mov    %al,%dl
80105bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bda:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105be0:	c9                   	leave  
80105be1:	c3                   	ret    

80105be2 <sys_mkdir>:

int
sys_mkdir(void)
{
80105be2:	55                   	push   %ebp
80105be3:	89 e5                	mov    %esp,%ebp
80105be5:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105be8:	e8 1e d6 ff ff       	call   8010320b <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bed:	83 ec 08             	sub    $0x8,%esp
80105bf0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf3:	50                   	push   %eax
80105bf4:	6a 00                	push   $0x0
80105bf6:	e8 85 f5 ff ff       	call   80105180 <argstr>
80105bfb:	83 c4 10             	add    $0x10,%esp
80105bfe:	85 c0                	test   %eax,%eax
80105c00:	78 1b                	js     80105c1d <sys_mkdir+0x3b>
80105c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c05:	6a 00                	push   $0x0
80105c07:	6a 00                	push   $0x0
80105c09:	6a 01                	push   $0x1
80105c0b:	50                   	push   %eax
80105c0c:	e8 80 fc ff ff       	call   80105891 <create>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c1b:	75 0c                	jne    80105c29 <sys_mkdir+0x47>
    commit_trans();
80105c1d:	e8 3b d6 ff ff       	call   8010325d <commit_trans>
    return -1;
80105c22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c27:	eb 18                	jmp    80105c41 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c2f:	e8 2d bf ff ff       	call   80101b61 <iunlockput>
80105c34:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105c37:	e8 21 d6 ff ff       	call   8010325d <commit_trans>
  return 0;
80105c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c41:	c9                   	leave  
80105c42:	c3                   	ret    

80105c43 <sys_mknod>:

int
sys_mknod(void)
{
80105c43:	55                   	push   %ebp
80105c44:	89 e5                	mov    %esp,%ebp
80105c46:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105c49:	e8 bd d5 ff ff       	call   8010320b <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105c4e:	83 ec 08             	sub    $0x8,%esp
80105c51:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c54:	50                   	push   %eax
80105c55:	6a 00                	push   $0x0
80105c57:	e8 24 f5 ff ff       	call   80105180 <argstr>
80105c5c:	83 c4 10             	add    $0x10,%esp
80105c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c66:	78 4f                	js     80105cb7 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80105c68:	83 ec 08             	sub    $0x8,%esp
80105c6b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c6e:	50                   	push   %eax
80105c6f:	6a 01                	push   $0x1
80105c71:	e8 82 f4 ff ff       	call   801050f8 <argint>
80105c76:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	78 3a                	js     80105cb7 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105c7d:	83 ec 08             	sub    $0x8,%esp
80105c80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c83:	50                   	push   %eax
80105c84:	6a 02                	push   $0x2
80105c86:	e8 6d f4 ff ff       	call   801050f8 <argint>
80105c8b:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105c8e:	85 c0                	test   %eax,%eax
80105c90:	78 25                	js     80105cb7 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c95:	0f bf c8             	movswl %ax,%ecx
80105c98:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c9b:	0f bf d0             	movswl %ax,%edx
80105c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105ca1:	51                   	push   %ecx
80105ca2:	52                   	push   %edx
80105ca3:	6a 03                	push   $0x3
80105ca5:	50                   	push   %eax
80105ca6:	e8 e6 fb ff ff       	call   80105891 <create>
80105cab:	83 c4 10             	add    $0x10,%esp
80105cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cb5:	75 0c                	jne    80105cc3 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80105cb7:	e8 a1 d5 ff ff       	call   8010325d <commit_trans>
    return -1;
80105cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc1:	eb 18                	jmp    80105cdb <sys_mknod+0x98>
  }
  iunlockput(ip);
80105cc3:	83 ec 0c             	sub    $0xc,%esp
80105cc6:	ff 75 f0             	pushl  -0x10(%ebp)
80105cc9:	e8 93 be ff ff       	call   80101b61 <iunlockput>
80105cce:	83 c4 10             	add    $0x10,%esp
  commit_trans();
80105cd1:	e8 87 d5 ff ff       	call   8010325d <commit_trans>
  return 0;
80105cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cdb:	c9                   	leave  
80105cdc:	c3                   	ret    

80105cdd <sys_chdir>:

int
sys_chdir(void)
{
80105cdd:	55                   	push   %ebp
80105cde:	89 e5                	mov    %esp,%ebp
80105ce0:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105ce3:	83 ec 08             	sub    $0x8,%esp
80105ce6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	e8 8f f4 ff ff       	call   80105180 <argstr>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	78 18                	js     80105d10 <sys_chdir+0x33>
80105cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfb:	83 ec 0c             	sub    $0xc,%esp
80105cfe:	50                   	push   %eax
80105cff:	e8 42 c7 ff ff       	call   80102446 <namei>
80105d04:	83 c4 10             	add    $0x10,%esp
80105d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d0e:	75 07                	jne    80105d17 <sys_chdir+0x3a>
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d15:	eb 63                	jmp    80105d7a <sys_chdir+0x9d>
  ilock(ip);
80105d17:	83 ec 0c             	sub    $0xc,%esp
80105d1a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1d:	e8 88 bb ff ff       	call   801018aa <ilock>
80105d22:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d28:	8b 40 10             	mov    0x10(%eax),%eax
80105d2b:	66 83 f8 01          	cmp    $0x1,%ax
80105d2f:	74 15                	je     80105d46 <sys_chdir+0x69>
    iunlockput(ip);
80105d31:	83 ec 0c             	sub    $0xc,%esp
80105d34:	ff 75 f4             	pushl  -0xc(%ebp)
80105d37:	e8 25 be ff ff       	call   80101b61 <iunlockput>
80105d3c:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d44:	eb 34                	jmp    80105d7a <sys_chdir+0x9d>
  }
  iunlock(ip);
80105d46:	83 ec 0c             	sub    $0xc,%esp
80105d49:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4c:	e8 b0 bc ff ff       	call   80101a01 <iunlock>
80105d51:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80105d54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d5a:	8b 40 68             	mov    0x68(%eax),%eax
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	50                   	push   %eax
80105d61:	e8 0c bd ff ff       	call   80101a72 <iput>
80105d66:	83 c4 10             	add    $0x10,%esp
  proc->cwd = ip;
80105d69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d72:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d7a:	c9                   	leave  
80105d7b:	c3                   	ret    

80105d7c <sys_exec>:

int
sys_exec(void)
{
80105d7c:	55                   	push   %ebp
80105d7d:	89 e5                	mov    %esp,%ebp
80105d7f:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d85:	83 ec 08             	sub    $0x8,%esp
80105d88:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d8b:	50                   	push   %eax
80105d8c:	6a 00                	push   $0x0
80105d8e:	e8 ed f3 ff ff       	call   80105180 <argstr>
80105d93:	83 c4 10             	add    $0x10,%esp
80105d96:	85 c0                	test   %eax,%eax
80105d98:	78 18                	js     80105db2 <sys_exec+0x36>
80105d9a:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	50                   	push   %eax
80105da4:	6a 01                	push   $0x1
80105da6:	e8 4d f3 ff ff       	call   801050f8 <argint>
80105dab:	83 c4 10             	add    $0x10,%esp
80105dae:	85 c0                	test   %eax,%eax
80105db0:	79 0a                	jns    80105dbc <sys_exec+0x40>
    return -1;
80105db2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db7:	e9 ca 00 00 00       	jmp    80105e86 <sys_exec+0x10a>
  }
  memset(argv, 0, sizeof(argv));
80105dbc:	83 ec 04             	sub    $0x4,%esp
80105dbf:	68 80 00 00 00       	push   $0x80
80105dc4:	6a 00                	push   $0x0
80105dc6:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105dcc:	50                   	push   %eax
80105dcd:	e8 08 f0 ff ff       	call   80104dda <memset>
80105dd2:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105dd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddf:	83 f8 1f             	cmp    $0x1f,%eax
80105de2:	76 0a                	jbe    80105dee <sys_exec+0x72>
      return -1;
80105de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de9:	e9 98 00 00 00       	jmp    80105e86 <sys_exec+0x10a>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dee:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df7:	c1 e2 02             	shl    $0x2,%edx
80105dfa:	89 d1                	mov    %edx,%ecx
80105dfc:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
80105e02:	8d 14 11             	lea    (%ecx,%edx,1),%edx
80105e05:	83 ec 08             	sub    $0x8,%esp
80105e08:	50                   	push   %eax
80105e09:	52                   	push   %edx
80105e0a:	e8 4d f2 ff ff       	call   8010505c <fetchint>
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	85 c0                	test   %eax,%eax
80105e14:	79 07                	jns    80105e1d <sys_exec+0xa1>
      return -1;
80105e16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1b:	eb 69                	jmp    80105e86 <sys_exec+0x10a>
    if(uarg == 0){
80105e1d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e23:	85 c0                	test   %eax,%eax
80105e25:	75 26                	jne    80105e4d <sys_exec+0xd1>
      argv[i] = 0;
80105e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105e31:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105e41:	52                   	push   %edx
80105e42:	50                   	push   %eax
80105e43:	e8 f4 ac ff ff       	call   80100b3c <exec>
80105e48:	83 c4 10             	add    $0x10,%esp
80105e4b:	eb 39                	jmp    80105e86 <sys_exec+0x10a>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105e57:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105e5d:	8d 14 10             	lea    (%eax,%edx,1),%edx
80105e60:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105e66:	83 ec 08             	sub    $0x8,%esp
80105e69:	52                   	push   %edx
80105e6a:	50                   	push   %eax
80105e6b:	e8 26 f2 ff ff       	call   80105096 <fetchstr>
80105e70:	83 c4 10             	add    $0x10,%esp
80105e73:	85 c0                	test   %eax,%eax
80105e75:	79 07                	jns    80105e7e <sys_exec+0x102>
      return -1;
80105e77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e7c:	eb 08                	jmp    80105e86 <sys_exec+0x10a>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105e7e:	ff 45 f4             	incl   -0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80105e81:	e9 56 ff ff ff       	jmp    80105ddc <sys_exec+0x60>
  return exec(path, argv);
}
80105e86:	c9                   	leave  
80105e87:	c3                   	ret    

80105e88 <sys_pipe>:

int
sys_pipe(void)
{
80105e88:	55                   	push   %ebp
80105e89:	89 e5                	mov    %esp,%ebp
80105e8b:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e91:	83 ec 04             	sub    $0x4,%esp
80105e94:	6a 08                	push   $0x8
80105e96:	50                   	push   %eax
80105e97:	6a 00                	push   $0x0
80105e99:	e8 83 f2 ff ff       	call   80105121 <argptr>
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	79 0a                	jns    80105eaf <sys_pipe+0x27>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eaa:	e9 af 00 00 00       	jmp    80105f5e <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80105eaf:	83 ec 08             	sub    $0x8,%esp
80105eb2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb5:	50                   	push   %eax
80105eb6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	e8 4d dd ff ff       	call   80103c0c <pipealloc>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	85 c0                	test   %eax,%eax
80105ec4:	79 0a                	jns    80105ed0 <sys_pipe+0x48>
    return -1;
80105ec6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ecb:	e9 8e 00 00 00       	jmp    80105f5e <sys_pipe+0xd6>
  fd0 = -1;
80105ed0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105eda:	83 ec 0c             	sub    $0xc,%esp
80105edd:	50                   	push   %eax
80105ede:	e8 ca f3 ff ff       	call   801052ad <fdalloc>
80105ee3:	83 c4 10             	add    $0x10,%esp
80105ee6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eed:	78 18                	js     80105f07 <sys_pipe+0x7f>
80105eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ef2:	83 ec 0c             	sub    $0xc,%esp
80105ef5:	50                   	push   %eax
80105ef6:	e8 b2 f3 ff ff       	call   801052ad <fdalloc>
80105efb:	83 c4 10             	add    $0x10,%esp
80105efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f05:	79 3f                	jns    80105f46 <sys_pipe+0xbe>
    if(fd0 >= 0)
80105f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f0b:	78 14                	js     80105f21 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80105f0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f16:	83 c2 08             	add    $0x8,%edx
80105f19:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105f20:	00 
    fileclose(rf);
80105f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f24:	83 ec 0c             	sub    $0xc,%esp
80105f27:	50                   	push   %eax
80105f28:	e8 b2 b0 ff ff       	call   80100fdf <fileclose>
80105f2d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80105f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f33:	83 ec 0c             	sub    $0xc,%esp
80105f36:	50                   	push   %eax
80105f37:	e8 a3 b0 ff ff       	call   80100fdf <fileclose>
80105f3c:	83 c4 10             	add    $0x10,%esp
    return -1;
80105f3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f44:	eb 18                	jmp    80105f5e <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80105f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f4c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80105f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105f51:	8d 50 04             	lea    0x4(%eax),%edx
80105f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f57:	89 02                	mov    %eax,(%edx)
  return 0;
80105f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f5e:	c9                   	leave  
80105f5f:	c3                   	ret    

80105f60 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105f66:	e8 8e e3 ff ff       	call   801042f9 <fork>
}
80105f6b:	c9                   	leave  
80105f6c:	c3                   	ret    

80105f6d <sys_exit>:

int
sys_exit(void)
{
80105f6d:	55                   	push   %ebp
80105f6e:	89 e5                	mov    %esp,%ebp
80105f70:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f73:	e8 ee e4 ff ff       	call   80104466 <exit>
  return 0;  // not reached
80105f78:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f7d:	c9                   	leave  
80105f7e:	c3                   	ret    

80105f7f <sys_wait>:

int
sys_wait(void)
{
80105f7f:	55                   	push   %ebp
80105f80:	89 e5                	mov    %esp,%ebp
80105f82:	83 ec 08             	sub    $0x8,%esp
  return wait();
80105f85:	e8 0a e6 ff ff       	call   80104594 <wait>
}
80105f8a:	c9                   	leave  
80105f8b:	c3                   	ret    

80105f8c <sys_kill>:

int
sys_kill(void)
{
80105f8c:	55                   	push   %ebp
80105f8d:	89 e5                	mov    %esp,%ebp
80105f8f:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f92:	83 ec 08             	sub    $0x8,%esp
80105f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f98:	50                   	push   %eax
80105f99:	6a 00                	push   $0x0
80105f9b:	e8 58 f1 ff ff       	call   801050f8 <argint>
80105fa0:	83 c4 10             	add    $0x10,%esp
80105fa3:	85 c0                	test   %eax,%eax
80105fa5:	79 07                	jns    80105fae <sys_kill+0x22>
    return -1;
80105fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fac:	eb 0f                	jmp    80105fbd <sys_kill+0x31>
  return kill(pid);
80105fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb1:	83 ec 0c             	sub    $0xc,%esp
80105fb4:	50                   	push   %eax
80105fb5:	e8 ea e9 ff ff       	call   801049a4 <kill>
80105fba:	83 c4 10             	add    $0x10,%esp
}
80105fbd:	c9                   	leave  
80105fbe:	c3                   	ret    

80105fbf <sys_getpid>:

int
sys_getpid(void)
{
80105fbf:	55                   	push   %ebp
80105fc0:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105fc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105fc8:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fcb:	c9                   	leave  
80105fcc:	c3                   	ret    

80105fcd <sys_sbrk>:

int
sys_sbrk(void)
{
80105fcd:	55                   	push   %ebp
80105fce:	89 e5                	mov    %esp,%ebp
80105fd0:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fd3:	83 ec 08             	sub    $0x8,%esp
80105fd6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fd9:	50                   	push   %eax
80105fda:	6a 00                	push   $0x0
80105fdc:	e8 17 f1 ff ff       	call   801050f8 <argint>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	79 07                	jns    80105fef <sys_sbrk+0x22>
    return -1;
80105fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fed:	eb 28                	jmp    80106017 <sys_sbrk+0x4a>
  addr = proc->sz;
80105fef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ff5:	8b 00                	mov    (%eax),%eax
80105ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80105ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	50                   	push   %eax
80106001:	e8 50 e2 ff ff       	call   80104256 <growproc>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	79 07                	jns    80106014 <sys_sbrk+0x47>
    return -1;
8010600d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106012:	eb 03                	jmp    80106017 <sys_sbrk+0x4a>
  return addr;
80106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106017:	c9                   	leave  
80106018:	c3                   	ret    

80106019 <sys_sleep>:

int
sys_sleep(void)
{
80106019:	55                   	push   %ebp
8010601a:	89 e5                	mov    %esp,%ebp
8010601c:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010601f:	83 ec 08             	sub    $0x8,%esp
80106022:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106025:	50                   	push   %eax
80106026:	6a 00                	push   $0x0
80106028:	e8 cb f0 ff ff       	call   801050f8 <argint>
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	85 c0                	test   %eax,%eax
80106032:	79 07                	jns    8010603b <sys_sleep+0x22>
    return -1;
80106034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106039:	eb 79                	jmp    801060b4 <sys_sleep+0x9b>
  acquire(&tickslock);
8010603b:	83 ec 0c             	sub    $0xc,%esp
8010603e:	68 60 1e 11 80       	push   $0x80111e60
80106043:	e8 3f eb ff ff       	call   80104b87 <acquire>
80106048:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
8010604b:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106050:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106053:	eb 39                	jmp    8010608e <sys_sleep+0x75>
    if(proc->killed){
80106055:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010605b:	8b 40 24             	mov    0x24(%eax),%eax
8010605e:	85 c0                	test   %eax,%eax
80106060:	74 17                	je     80106079 <sys_sleep+0x60>
      release(&tickslock);
80106062:	83 ec 0c             	sub    $0xc,%esp
80106065:	68 60 1e 11 80       	push   $0x80111e60
8010606a:	e8 7e eb ff ff       	call   80104bed <release>
8010606f:	83 c4 10             	add    $0x10,%esp
      return -1;
80106072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106077:	eb 3b                	jmp    801060b4 <sys_sleep+0x9b>
    }
    sleep(&ticks, &tickslock);
80106079:	83 ec 08             	sub    $0x8,%esp
8010607c:	68 60 1e 11 80       	push   $0x80111e60
80106081:	68 a0 26 11 80       	push   $0x801126a0
80106086:	e8 f9 e7 ff ff       	call   80104884 <sleep>
8010608b:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010608e:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80106093:	89 c2                	mov    %eax,%edx
80106095:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106098:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010609b:	39 c2                	cmp    %eax,%edx
8010609d:	72 b6                	jb     80106055 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
8010609f:	83 ec 0c             	sub    $0xc,%esp
801060a2:	68 60 1e 11 80       	push   $0x80111e60
801060a7:	e8 41 eb ff ff       	call   80104bed <release>
801060ac:	83 c4 10             	add    $0x10,%esp
  return 0;
801060af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060b4:	c9                   	leave  
801060b5:	c3                   	ret    

801060b6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060b6:	55                   	push   %ebp
801060b7:	89 e5                	mov    %esp,%ebp
801060b9:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801060bc:	83 ec 0c             	sub    $0xc,%esp
801060bf:	68 60 1e 11 80       	push   $0x80111e60
801060c4:	e8 be ea ff ff       	call   80104b87 <acquire>
801060c9:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801060cc:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801060d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801060d4:	83 ec 0c             	sub    $0xc,%esp
801060d7:	68 60 1e 11 80       	push   $0x80111e60
801060dc:	e8 0c eb ff ff       	call   80104bed <release>
801060e1:	83 c4 10             	add    $0x10,%esp
  return xticks;
801060e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801060e7:	c9                   	leave  
801060e8:	c3                   	ret    
801060e9:	00 00                	add    %al,(%eax)
	...

801060ec <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801060ec:	55                   	push   %ebp
801060ed:	89 e5                	mov    %esp,%ebp
801060ef:	83 ec 08             	sub    $0x8,%esp
801060f2:	8b 45 08             	mov    0x8(%ebp),%eax
801060f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801060f8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801060fc:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060ff:	8a 45 f8             	mov    -0x8(%ebp),%al
80106102:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106105:	ee                   	out    %al,(%dx)
}
80106106:	c9                   	leave  
80106107:	c3                   	ret    

80106108 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106108:	55                   	push   %ebp
80106109:	89 e5                	mov    %esp,%ebp
8010610b:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010610e:	6a 34                	push   $0x34
80106110:	6a 43                	push   $0x43
80106112:	e8 d5 ff ff ff       	call   801060ec <outb>
80106117:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010611a:	68 9c 00 00 00       	push   $0x9c
8010611f:	6a 40                	push   $0x40
80106121:	e8 c6 ff ff ff       	call   801060ec <outb>
80106126:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106129:	6a 2e                	push   $0x2e
8010612b:	6a 40                	push   $0x40
8010612d:	e8 ba ff ff ff       	call   801060ec <outb>
80106132:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106135:	83 ec 0c             	sub    $0xc,%esp
80106138:	6a 00                	push   $0x0
8010613a:	e8 b6 d9 ff ff       	call   80103af5 <picenable>
8010613f:	83 c4 10             	add    $0x10,%esp
}
80106142:	c9                   	leave  
80106143:	c3                   	ret    

80106144 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106144:	1e                   	push   %ds
  pushl %es
80106145:	06                   	push   %es
  pushl %fs
80106146:	0f a0                	push   %fs
  pushl %gs
80106148:	0f a8                	push   %gs
  pushal
8010614a:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010614b:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010614f:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106151:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106153:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106157:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106159:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010615b:	54                   	push   %esp
  call trap
8010615c:	e8 c1 01 00 00       	call   80106322 <trap>
  addl $4, %esp
80106161:	83 c4 04             	add    $0x4,%esp

80106164 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106164:	61                   	popa   
  popl %gs
80106165:	0f a9                	pop    %gs
  popl %fs
80106167:	0f a1                	pop    %fs
  popl %es
80106169:	07                   	pop    %es
  popl %ds
8010616a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010616b:	83 c4 08             	add    $0x8,%esp
  iret
8010616e:	cf                   	iret   
	...

80106170 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106176:	8b 45 0c             	mov    0xc(%ebp),%eax
80106179:	48                   	dec    %eax
8010617a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010617e:	8b 45 08             	mov    0x8(%ebp),%eax
80106181:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106185:	8b 45 08             	mov    0x8(%ebp),%eax
80106188:	c1 e8 10             	shr    $0x10,%eax
8010618b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010618f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106192:	0f 01 18             	lidtl  (%eax)
}
80106195:	c9                   	leave  
80106196:	c3                   	ret    

80106197 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106197:	55                   	push   %ebp
80106198:	89 e5                	mov    %esp,%ebp
8010619a:	53                   	push   %ebx
8010619b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010619e:	0f 20 d3             	mov    %cr2,%ebx
801061a1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
801061a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801061a7:	83 c4 10             	add    $0x10,%esp
801061aa:	5b                   	pop    %ebx
801061ab:	c9                   	leave  
801061ac:	c3                   	ret    

801061ad <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061ad:	55                   	push   %ebp
801061ae:	89 e5                	mov    %esp,%ebp
801061b0:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
801061b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061ba:	e9 b8 00 00 00       	jmp    80106277 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c2:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801061c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061cc:	66 89 04 d5 a0 1e 11 	mov    %ax,-0x7feee160(,%edx,8)
801061d3:	80 
801061d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d7:	66 c7 04 c5 a2 1e 11 	movw   $0x8,-0x7feee15e(,%eax,8)
801061de:	80 08 00 
801061e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e4:	8a 14 c5 a4 1e 11 80 	mov    -0x7feee15c(,%eax,8),%dl
801061eb:	83 e2 e0             	and    $0xffffffe0,%edx
801061ee:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
801061f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f8:	8a 14 c5 a4 1e 11 80 	mov    -0x7feee15c(,%eax,8),%dl
801061ff:	83 e2 1f             	and    $0x1f,%edx
80106202:	88 14 c5 a4 1e 11 80 	mov    %dl,-0x7feee15c(,%eax,8)
80106209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620c:	8a 14 c5 a5 1e 11 80 	mov    -0x7feee15b(,%eax,8),%dl
80106213:	83 e2 f0             	and    $0xfffffff0,%edx
80106216:	83 ca 0e             	or     $0xe,%edx
80106219:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106223:	8a 14 c5 a5 1e 11 80 	mov    -0x7feee15b(,%eax,8),%dl
8010622a:	83 e2 ef             	and    $0xffffffef,%edx
8010622d:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106237:	8a 14 c5 a5 1e 11 80 	mov    -0x7feee15b(,%eax,8),%dl
8010623e:	83 e2 9f             	and    $0xffffff9f,%edx
80106241:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
80106248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624b:	8a 14 c5 a5 1e 11 80 	mov    -0x7feee15b(,%eax,8),%dl
80106252:	83 ca 80             	or     $0xffffff80,%edx
80106255:	88 14 c5 a5 1e 11 80 	mov    %dl,-0x7feee15b(,%eax,8)
8010625c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625f:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106266:	c1 e8 10             	shr    $0x10,%eax
80106269:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010626c:	66 89 04 d5 a6 1e 11 	mov    %ax,-0x7feee15a(,%edx,8)
80106273:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106274:	ff 45 f4             	incl   -0xc(%ebp)
80106277:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
8010627e:	0f 8e 3b ff ff ff    	jle    801061bf <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106284:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106289:	66 a3 a0 20 11 80    	mov    %ax,0x801120a0
8010628f:	66 c7 05 a2 20 11 80 	movw   $0x8,0x801120a2
80106296:	08 00 
80106298:	a0 a4 20 11 80       	mov    0x801120a4,%al
8010629d:	83 e0 e0             	and    $0xffffffe0,%eax
801062a0:	a2 a4 20 11 80       	mov    %al,0x801120a4
801062a5:	a0 a4 20 11 80       	mov    0x801120a4,%al
801062aa:	83 e0 1f             	and    $0x1f,%eax
801062ad:	a2 a4 20 11 80       	mov    %al,0x801120a4
801062b2:	a0 a5 20 11 80       	mov    0x801120a5,%al
801062b7:	83 c8 0f             	or     $0xf,%eax
801062ba:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062bf:	a0 a5 20 11 80       	mov    0x801120a5,%al
801062c4:	83 e0 ef             	and    $0xffffffef,%eax
801062c7:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062cc:	a0 a5 20 11 80       	mov    0x801120a5,%al
801062d1:	83 c8 60             	or     $0x60,%eax
801062d4:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062d9:	a0 a5 20 11 80       	mov    0x801120a5,%al
801062de:	83 c8 80             	or     $0xffffff80,%eax
801062e1:	a2 a5 20 11 80       	mov    %al,0x801120a5
801062e6:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801062eb:	c1 e8 10             	shr    $0x10,%eax
801062ee:	66 a3 a6 20 11 80    	mov    %ax,0x801120a6
  
  initlock(&tickslock, "time");
801062f4:	83 ec 08             	sub    $0x8,%esp
801062f7:	68 28 84 10 80       	push   $0x80108428
801062fc:	68 60 1e 11 80       	push   $0x80111e60
80106301:	e8 60 e8 ff ff       	call   80104b66 <initlock>
80106306:	83 c4 10             	add    $0x10,%esp
}
80106309:	c9                   	leave  
8010630a:	c3                   	ret    

8010630b <idtinit>:

void
idtinit(void)
{
8010630b:	55                   	push   %ebp
8010630c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010630e:	68 00 08 00 00       	push   $0x800
80106313:	68 a0 1e 11 80       	push   $0x80111ea0
80106318:	e8 53 fe ff ff       	call   80106170 <lidt>
8010631d:	83 c4 08             	add    $0x8,%esp
}
80106320:	c9                   	leave  
80106321:	c3                   	ret    

80106322 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106322:	55                   	push   %ebp
80106323:	89 e5                	mov    %esp,%ebp
80106325:	57                   	push   %edi
80106326:	56                   	push   %esi
80106327:	53                   	push   %ebx
80106328:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010632b:	8b 45 08             	mov    0x8(%ebp),%eax
8010632e:	8b 40 30             	mov    0x30(%eax),%eax
80106331:	83 f8 40             	cmp    $0x40,%eax
80106334:	75 3e                	jne    80106374 <trap+0x52>
    if(proc->killed)
80106336:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010633c:	8b 40 24             	mov    0x24(%eax),%eax
8010633f:	85 c0                	test   %eax,%eax
80106341:	74 05                	je     80106348 <trap+0x26>
      exit();
80106343:	e8 1e e1 ff ff       	call   80104466 <exit>
    proc->tf = tf;
80106348:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010634e:	8b 55 08             	mov    0x8(%ebp),%edx
80106351:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106354:	e8 58 ee ff ff       	call   801051b1 <syscall>
    if(proc->killed)
80106359:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010635f:	8b 40 24             	mov    0x24(%eax),%eax
80106362:	85 c0                	test   %eax,%eax
80106364:	0f 84 12 02 00 00    	je     8010657c <trap+0x25a>
      exit();
8010636a:	e8 f7 e0 ff ff       	call   80104466 <exit>
    return;
8010636f:	e9 09 02 00 00       	jmp    8010657d <trap+0x25b>
  }

  switch(tf->trapno){
80106374:	8b 45 08             	mov    0x8(%ebp),%eax
80106377:	8b 40 30             	mov    0x30(%eax),%eax
8010637a:	83 e8 20             	sub    $0x20,%eax
8010637d:	83 f8 1f             	cmp    $0x1f,%eax
80106380:	0f 87 bb 00 00 00    	ja     80106441 <trap+0x11f>
80106386:	8b 04 85 d0 84 10 80 	mov    -0x7fef7b30(,%eax,4),%eax
8010638d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010638f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106395:	8a 00                	mov    (%eax),%al
80106397:	84 c0                	test   %al,%al
80106399:	75 3b                	jne    801063d6 <trap+0xb4>
      acquire(&tickslock);
8010639b:	83 ec 0c             	sub    $0xc,%esp
8010639e:	68 60 1e 11 80       	push   $0x80111e60
801063a3:	e8 df e7 ff ff       	call   80104b87 <acquire>
801063a8:	83 c4 10             	add    $0x10,%esp
      ticks++;
801063ab:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801063b0:	40                   	inc    %eax
801063b1:	a3 a0 26 11 80       	mov    %eax,0x801126a0
      wakeup(&ticks);
801063b6:	83 ec 0c             	sub    $0xc,%esp
801063b9:	68 a0 26 11 80       	push   $0x801126a0
801063be:	e8 ab e5 ff ff       	call   8010496e <wakeup>
801063c3:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
801063c6:	83 ec 0c             	sub    $0xc,%esp
801063c9:	68 60 1e 11 80       	push   $0x80111e60
801063ce:	e8 1a e8 ff ff       	call   80104bed <release>
801063d3:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801063d6:	e8 17 cb ff ff       	call   80102ef2 <lapiceoi>
    break;
801063db:	e9 18 01 00 00       	jmp    801064f8 <trap+0x1d6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801063e0:	e8 39 c3 ff ff       	call   8010271e <ideintr>
    lapiceoi();
801063e5:	e8 08 cb ff ff       	call   80102ef2 <lapiceoi>
    break;
801063ea:	e9 09 01 00 00       	jmp    801064f8 <trap+0x1d6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801063ef:	e8 15 c9 ff ff       	call   80102d09 <kbdintr>
    lapiceoi();
801063f4:	e8 f9 ca ff ff       	call   80102ef2 <lapiceoi>
    break;
801063f9:	e9 fa 00 00 00       	jmp    801064f8 <trap+0x1d6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801063fe:	e8 61 03 00 00       	call   80106764 <uartintr>
    lapiceoi();
80106403:	e8 ea ca ff ff       	call   80102ef2 <lapiceoi>
    break;
80106408:	e9 eb 00 00 00       	jmp    801064f8 <trap+0x1d6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
8010640d:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106410:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106413:	8b 45 08             	mov    0x8(%ebp),%eax
80106416:	8b 40 3c             	mov    0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106419:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010641c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106422:	8a 00                	mov    (%eax),%al
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106424:	0f b6 c0             	movzbl %al,%eax
80106427:	51                   	push   %ecx
80106428:	52                   	push   %edx
80106429:	50                   	push   %eax
8010642a:	68 30 84 10 80       	push   $0x80108430
8010642f:	e8 8c 9f ff ff       	call   801003c0 <cprintf>
80106434:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106437:	e8 b6 ca ff ff       	call   80102ef2 <lapiceoi>
    break;
8010643c:	e9 b7 00 00 00       	jmp    801064f8 <trap+0x1d6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106441:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106447:	85 c0                	test   %eax,%eax
80106449:	74 10                	je     8010645b <trap+0x139>
8010644b:	8b 45 08             	mov    0x8(%ebp),%eax
8010644e:	8b 40 3c             	mov    0x3c(%eax),%eax
80106451:	0f b7 c0             	movzwl %ax,%eax
80106454:	83 e0 03             	and    $0x3,%eax
80106457:	85 c0                	test   %eax,%eax
80106459:	75 3e                	jne    80106499 <trap+0x177>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010645b:	e8 37 fd ff ff       	call   80106197 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80106460:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106463:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106466:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010646d:	8a 12                	mov    (%edx),%dl
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010646f:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106472:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106475:	8b 52 30             	mov    0x30(%edx),%edx
80106478:	83 ec 0c             	sub    $0xc,%esp
8010647b:	50                   	push   %eax
8010647c:	53                   	push   %ebx
8010647d:	51                   	push   %ecx
8010647e:	52                   	push   %edx
8010647f:	68 54 84 10 80       	push   $0x80108454
80106484:	e8 37 9f ff ff       	call   801003c0 <cprintf>
80106489:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010648c:	83 ec 0c             	sub    $0xc,%esp
8010648f:	68 86 84 10 80       	push   $0x80108486
80106494:	e8 c6 a0 ff ff       	call   8010055f <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106499:	e8 f9 fc ff ff       	call   80106197 <rcr2>
8010649e:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064a0:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064a3:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801064ac:	8a 00                	mov    (%eax),%al
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064ae:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064b1:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064b4:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064b7:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064ba:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064c3:	83 c0 6c             	add    $0x6c,%eax
801064c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801064c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801064cf:	8b 40 10             	mov    0x10(%eax),%eax
801064d2:	52                   	push   %edx
801064d3:	57                   	push   %edi
801064d4:	56                   	push   %esi
801064d5:	53                   	push   %ebx
801064d6:	51                   	push   %ecx
801064d7:	ff 75 e4             	pushl  -0x1c(%ebp)
801064da:	50                   	push   %eax
801064db:	68 8c 84 10 80       	push   $0x8010848c
801064e0:	e8 db 9e ff ff       	call   801003c0 <cprintf>
801064e5:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801064e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064ee:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801064f5:	eb 01                	jmp    801064f8 <trap+0x1d6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801064f7:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801064f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064fe:	85 c0                	test   %eax,%eax
80106500:	74 23                	je     80106525 <trap+0x203>
80106502:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106508:	8b 40 24             	mov    0x24(%eax),%eax
8010650b:	85 c0                	test   %eax,%eax
8010650d:	74 16                	je     80106525 <trap+0x203>
8010650f:	8b 45 08             	mov    0x8(%ebp),%eax
80106512:	8b 40 3c             	mov    0x3c(%eax),%eax
80106515:	0f b7 c0             	movzwl %ax,%eax
80106518:	83 e0 03             	and    $0x3,%eax
8010651b:	83 f8 03             	cmp    $0x3,%eax
8010651e:	75 05                	jne    80106525 <trap+0x203>
    exit();
80106520:	e8 41 df ff ff       	call   80104466 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106525:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010652b:	85 c0                	test   %eax,%eax
8010652d:	74 1e                	je     8010654d <trap+0x22b>
8010652f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106535:	8b 40 0c             	mov    0xc(%eax),%eax
80106538:	83 f8 04             	cmp    $0x4,%eax
8010653b:	75 10                	jne    8010654d <trap+0x22b>
8010653d:	8b 45 08             	mov    0x8(%ebp),%eax
80106540:	8b 40 30             	mov    0x30(%eax),%eax
80106543:	83 f8 20             	cmp    $0x20,%eax
80106546:	75 05                	jne    8010654d <trap+0x22b>
    yield();
80106548:	e8 cd e2 ff ff       	call   8010481a <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010654d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106553:	85 c0                	test   %eax,%eax
80106555:	74 26                	je     8010657d <trap+0x25b>
80106557:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010655d:	8b 40 24             	mov    0x24(%eax),%eax
80106560:	85 c0                	test   %eax,%eax
80106562:	74 19                	je     8010657d <trap+0x25b>
80106564:	8b 45 08             	mov    0x8(%ebp),%eax
80106567:	8b 40 3c             	mov    0x3c(%eax),%eax
8010656a:	0f b7 c0             	movzwl %ax,%eax
8010656d:	83 e0 03             	and    $0x3,%eax
80106570:	83 f8 03             	cmp    $0x3,%eax
80106573:	75 08                	jne    8010657d <trap+0x25b>
    exit();
80106575:	e8 ec de ff ff       	call   80104466 <exit>
8010657a:	eb 01                	jmp    8010657d <trap+0x25b>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010657c:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010657d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106580:	83 c4 00             	add    $0x0,%esp
80106583:	5b                   	pop    %ebx
80106584:	5e                   	pop    %esi
80106585:	5f                   	pop    %edi
80106586:	c9                   	leave  
80106587:	c3                   	ret    

80106588 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106588:	55                   	push   %ebp
80106589:	89 e5                	mov    %esp,%ebp
8010658b:	53                   	push   %ebx
8010658c:	83 ec 18             	sub    $0x18,%esp
8010658f:	8b 45 08             	mov    0x8(%ebp),%eax
80106592:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106596:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106599:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
8010659d:	66 8b 55 e6          	mov    -0x1a(%ebp),%dx
801065a1:	ec                   	in     (%dx),%al
801065a2:	88 c3                	mov    %al,%bl
801065a4:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801065a7:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801065aa:	83 c4 18             	add    $0x18,%esp
801065ad:	5b                   	pop    %ebx
801065ae:	c9                   	leave  
801065af:	c3                   	ret    

801065b0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 08             	sub    $0x8,%esp
801065b6:	8b 45 08             	mov    0x8(%ebp),%eax
801065b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801065bc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801065c0:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065c3:	8a 45 f8             	mov    -0x8(%ebp),%al
801065c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065c9:	ee                   	out    %al,(%dx)
}
801065ca:	c9                   	leave  
801065cb:	c3                   	ret    

801065cc <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801065cc:	55                   	push   %ebp
801065cd:	89 e5                	mov    %esp,%ebp
801065cf:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801065d2:	6a 00                	push   $0x0
801065d4:	68 fa 03 00 00       	push   $0x3fa
801065d9:	e8 d2 ff ff ff       	call   801065b0 <outb>
801065de:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801065e1:	68 80 00 00 00       	push   $0x80
801065e6:	68 fb 03 00 00       	push   $0x3fb
801065eb:	e8 c0 ff ff ff       	call   801065b0 <outb>
801065f0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801065f3:	6a 0c                	push   $0xc
801065f5:	68 f8 03 00 00       	push   $0x3f8
801065fa:	e8 b1 ff ff ff       	call   801065b0 <outb>
801065ff:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106602:	6a 00                	push   $0x0
80106604:	68 f9 03 00 00       	push   $0x3f9
80106609:	e8 a2 ff ff ff       	call   801065b0 <outb>
8010660e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106611:	6a 03                	push   $0x3
80106613:	68 fb 03 00 00       	push   $0x3fb
80106618:	e8 93 ff ff ff       	call   801065b0 <outb>
8010661d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106620:	6a 00                	push   $0x0
80106622:	68 fc 03 00 00       	push   $0x3fc
80106627:	e8 84 ff ff ff       	call   801065b0 <outb>
8010662c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010662f:	6a 01                	push   $0x1
80106631:	68 f9 03 00 00       	push   $0x3f9
80106636:	e8 75 ff ff ff       	call   801065b0 <outb>
8010663b:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010663e:	68 fd 03 00 00       	push   $0x3fd
80106643:	e8 40 ff ff ff       	call   80106588 <inb>
80106648:	83 c4 04             	add    $0x4,%esp
8010664b:	3c ff                	cmp    $0xff,%al
8010664d:	74 6b                	je     801066ba <uartinit+0xee>
    return;
  uart = 1;
8010664f:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106656:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106659:	68 fa 03 00 00       	push   $0x3fa
8010665e:	e8 25 ff ff ff       	call   80106588 <inb>
80106663:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106666:	68 f8 03 00 00       	push   $0x3f8
8010666b:	e8 18 ff ff ff       	call   80106588 <inb>
80106670:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106673:	83 ec 0c             	sub    $0xc,%esp
80106676:	6a 04                	push   $0x4
80106678:	e8 78 d4 ff ff       	call   80103af5 <picenable>
8010667d:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106680:	83 ec 08             	sub    $0x8,%esp
80106683:	6a 00                	push   $0x0
80106685:	6a 04                	push   $0x4
80106687:	e8 30 c3 ff ff       	call   801029bc <ioapicenable>
8010668c:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010668f:	c7 45 f4 50 85 10 80 	movl   $0x80108550,-0xc(%ebp)
80106696:	eb 17                	jmp    801066af <uartinit+0xe3>
    uartputc(*p);
80106698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669b:	8a 00                	mov    (%eax),%al
8010669d:	0f be c0             	movsbl %al,%eax
801066a0:	83 ec 0c             	sub    $0xc,%esp
801066a3:	50                   	push   %eax
801066a4:	e8 14 00 00 00       	call   801066bd <uartputc>
801066a9:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801066ac:	ff 45 f4             	incl   -0xc(%ebp)
801066af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b2:	8a 00                	mov    (%eax),%al
801066b4:	84 c0                	test   %al,%al
801066b6:	75 e0                	jne    80106698 <uartinit+0xcc>
801066b8:	eb 01                	jmp    801066bb <uartinit+0xef>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801066ba:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801066bb:	c9                   	leave  
801066bc:	c3                   	ret    

801066bd <uartputc>:

void
uartputc(int c)
{
801066bd:	55                   	push   %ebp
801066be:	89 e5                	mov    %esp,%ebp
801066c0:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801066c3:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801066c8:	85 c0                	test   %eax,%eax
801066ca:	74 52                	je     8010671e <uartputc+0x61>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801066d3:	eb 10                	jmp    801066e5 <uartputc+0x28>
    microdelay(10);
801066d5:	83 ec 0c             	sub    $0xc,%esp
801066d8:	6a 0a                	push   $0xa
801066da:	e8 2d c8 ff ff       	call   80102f0c <microdelay>
801066df:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066e2:	ff 45 f4             	incl   -0xc(%ebp)
801066e5:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801066e9:	7f 1a                	jg     80106705 <uartputc+0x48>
801066eb:	83 ec 0c             	sub    $0xc,%esp
801066ee:	68 fd 03 00 00       	push   $0x3fd
801066f3:	e8 90 fe ff ff       	call   80106588 <inb>
801066f8:	83 c4 10             	add    $0x10,%esp
801066fb:	0f b6 c0             	movzbl %al,%eax
801066fe:	83 e0 20             	and    $0x20,%eax
80106701:	85 c0                	test   %eax,%eax
80106703:	74 d0                	je     801066d5 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106705:	8b 45 08             	mov    0x8(%ebp),%eax
80106708:	0f b6 c0             	movzbl %al,%eax
8010670b:	83 ec 08             	sub    $0x8,%esp
8010670e:	50                   	push   %eax
8010670f:	68 f8 03 00 00       	push   $0x3f8
80106714:	e8 97 fe ff ff       	call   801065b0 <outb>
80106719:	83 c4 10             	add    $0x10,%esp
8010671c:	eb 01                	jmp    8010671f <uartputc+0x62>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
8010671e:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010671f:	c9                   	leave  
80106720:	c3                   	ret    

80106721 <uartgetc>:

static int
uartgetc(void)
{
80106721:	55                   	push   %ebp
80106722:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106724:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106729:	85 c0                	test   %eax,%eax
8010672b:	75 07                	jne    80106734 <uartgetc+0x13>
    return -1;
8010672d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106732:	eb 2e                	jmp    80106762 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106734:	68 fd 03 00 00       	push   $0x3fd
80106739:	e8 4a fe ff ff       	call   80106588 <inb>
8010673e:	83 c4 04             	add    $0x4,%esp
80106741:	0f b6 c0             	movzbl %al,%eax
80106744:	83 e0 01             	and    $0x1,%eax
80106747:	85 c0                	test   %eax,%eax
80106749:	75 07                	jne    80106752 <uartgetc+0x31>
    return -1;
8010674b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106750:	eb 10                	jmp    80106762 <uartgetc+0x41>
  return inb(COM1+0);
80106752:	68 f8 03 00 00       	push   $0x3f8
80106757:	e8 2c fe ff ff       	call   80106588 <inb>
8010675c:	83 c4 04             	add    $0x4,%esp
8010675f:	0f b6 c0             	movzbl %al,%eax
}
80106762:	c9                   	leave  
80106763:	c3                   	ret    

80106764 <uartintr>:

void
uartintr(void)
{
80106764:	55                   	push   %ebp
80106765:	89 e5                	mov    %esp,%ebp
80106767:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010676a:	83 ec 0c             	sub    $0xc,%esp
8010676d:	68 21 67 10 80       	push   $0x80106721
80106772:	e8 46 a0 ff ff       	call   801007bd <consoleintr>
80106777:	83 c4 10             	add    $0x10,%esp
}
8010677a:	c9                   	leave  
8010677b:	c3                   	ret    

8010677c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $0
8010677e:	6a 00                	push   $0x0
  jmp alltraps
80106780:	e9 bf f9 ff ff       	jmp    80106144 <alltraps>

80106785 <vector1>:
.globl vector1
vector1:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $1
80106787:	6a 01                	push   $0x1
  jmp alltraps
80106789:	e9 b6 f9 ff ff       	jmp    80106144 <alltraps>

8010678e <vector2>:
.globl vector2
vector2:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $2
80106790:	6a 02                	push   $0x2
  jmp alltraps
80106792:	e9 ad f9 ff ff       	jmp    80106144 <alltraps>

80106797 <vector3>:
.globl vector3
vector3:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $3
80106799:	6a 03                	push   $0x3
  jmp alltraps
8010679b:	e9 a4 f9 ff ff       	jmp    80106144 <alltraps>

801067a0 <vector4>:
.globl vector4
vector4:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $4
801067a2:	6a 04                	push   $0x4
  jmp alltraps
801067a4:	e9 9b f9 ff ff       	jmp    80106144 <alltraps>

801067a9 <vector5>:
.globl vector5
vector5:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $5
801067ab:	6a 05                	push   $0x5
  jmp alltraps
801067ad:	e9 92 f9 ff ff       	jmp    80106144 <alltraps>

801067b2 <vector6>:
.globl vector6
vector6:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $6
801067b4:	6a 06                	push   $0x6
  jmp alltraps
801067b6:	e9 89 f9 ff ff       	jmp    80106144 <alltraps>

801067bb <vector7>:
.globl vector7
vector7:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $7
801067bd:	6a 07                	push   $0x7
  jmp alltraps
801067bf:	e9 80 f9 ff ff       	jmp    80106144 <alltraps>

801067c4 <vector8>:
.globl vector8
vector8:
  pushl $8
801067c4:	6a 08                	push   $0x8
  jmp alltraps
801067c6:	e9 79 f9 ff ff       	jmp    80106144 <alltraps>

801067cb <vector9>:
.globl vector9
vector9:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $9
801067cd:	6a 09                	push   $0x9
  jmp alltraps
801067cf:	e9 70 f9 ff ff       	jmp    80106144 <alltraps>

801067d4 <vector10>:
.globl vector10
vector10:
  pushl $10
801067d4:	6a 0a                	push   $0xa
  jmp alltraps
801067d6:	e9 69 f9 ff ff       	jmp    80106144 <alltraps>

801067db <vector11>:
.globl vector11
vector11:
  pushl $11
801067db:	6a 0b                	push   $0xb
  jmp alltraps
801067dd:	e9 62 f9 ff ff       	jmp    80106144 <alltraps>

801067e2 <vector12>:
.globl vector12
vector12:
  pushl $12
801067e2:	6a 0c                	push   $0xc
  jmp alltraps
801067e4:	e9 5b f9 ff ff       	jmp    80106144 <alltraps>

801067e9 <vector13>:
.globl vector13
vector13:
  pushl $13
801067e9:	6a 0d                	push   $0xd
  jmp alltraps
801067eb:	e9 54 f9 ff ff       	jmp    80106144 <alltraps>

801067f0 <vector14>:
.globl vector14
vector14:
  pushl $14
801067f0:	6a 0e                	push   $0xe
  jmp alltraps
801067f2:	e9 4d f9 ff ff       	jmp    80106144 <alltraps>

801067f7 <vector15>:
.globl vector15
vector15:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $15
801067f9:	6a 0f                	push   $0xf
  jmp alltraps
801067fb:	e9 44 f9 ff ff       	jmp    80106144 <alltraps>

80106800 <vector16>:
.globl vector16
vector16:
  pushl $0
80106800:	6a 00                	push   $0x0
  pushl $16
80106802:	6a 10                	push   $0x10
  jmp alltraps
80106804:	e9 3b f9 ff ff       	jmp    80106144 <alltraps>

80106809 <vector17>:
.globl vector17
vector17:
  pushl $17
80106809:	6a 11                	push   $0x11
  jmp alltraps
8010680b:	e9 34 f9 ff ff       	jmp    80106144 <alltraps>

80106810 <vector18>:
.globl vector18
vector18:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $18
80106812:	6a 12                	push   $0x12
  jmp alltraps
80106814:	e9 2b f9 ff ff       	jmp    80106144 <alltraps>

80106819 <vector19>:
.globl vector19
vector19:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $19
8010681b:	6a 13                	push   $0x13
  jmp alltraps
8010681d:	e9 22 f9 ff ff       	jmp    80106144 <alltraps>

80106822 <vector20>:
.globl vector20
vector20:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $20
80106824:	6a 14                	push   $0x14
  jmp alltraps
80106826:	e9 19 f9 ff ff       	jmp    80106144 <alltraps>

8010682b <vector21>:
.globl vector21
vector21:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $21
8010682d:	6a 15                	push   $0x15
  jmp alltraps
8010682f:	e9 10 f9 ff ff       	jmp    80106144 <alltraps>

80106834 <vector22>:
.globl vector22
vector22:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $22
80106836:	6a 16                	push   $0x16
  jmp alltraps
80106838:	e9 07 f9 ff ff       	jmp    80106144 <alltraps>

8010683d <vector23>:
.globl vector23
vector23:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $23
8010683f:	6a 17                	push   $0x17
  jmp alltraps
80106841:	e9 fe f8 ff ff       	jmp    80106144 <alltraps>

80106846 <vector24>:
.globl vector24
vector24:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $24
80106848:	6a 18                	push   $0x18
  jmp alltraps
8010684a:	e9 f5 f8 ff ff       	jmp    80106144 <alltraps>

8010684f <vector25>:
.globl vector25
vector25:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $25
80106851:	6a 19                	push   $0x19
  jmp alltraps
80106853:	e9 ec f8 ff ff       	jmp    80106144 <alltraps>

80106858 <vector26>:
.globl vector26
vector26:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $26
8010685a:	6a 1a                	push   $0x1a
  jmp alltraps
8010685c:	e9 e3 f8 ff ff       	jmp    80106144 <alltraps>

80106861 <vector27>:
.globl vector27
vector27:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $27
80106863:	6a 1b                	push   $0x1b
  jmp alltraps
80106865:	e9 da f8 ff ff       	jmp    80106144 <alltraps>

8010686a <vector28>:
.globl vector28
vector28:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $28
8010686c:	6a 1c                	push   $0x1c
  jmp alltraps
8010686e:	e9 d1 f8 ff ff       	jmp    80106144 <alltraps>

80106873 <vector29>:
.globl vector29
vector29:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $29
80106875:	6a 1d                	push   $0x1d
  jmp alltraps
80106877:	e9 c8 f8 ff ff       	jmp    80106144 <alltraps>

8010687c <vector30>:
.globl vector30
vector30:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $30
8010687e:	6a 1e                	push   $0x1e
  jmp alltraps
80106880:	e9 bf f8 ff ff       	jmp    80106144 <alltraps>

80106885 <vector31>:
.globl vector31
vector31:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $31
80106887:	6a 1f                	push   $0x1f
  jmp alltraps
80106889:	e9 b6 f8 ff ff       	jmp    80106144 <alltraps>

8010688e <vector32>:
.globl vector32
vector32:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $32
80106890:	6a 20                	push   $0x20
  jmp alltraps
80106892:	e9 ad f8 ff ff       	jmp    80106144 <alltraps>

80106897 <vector33>:
.globl vector33
vector33:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $33
80106899:	6a 21                	push   $0x21
  jmp alltraps
8010689b:	e9 a4 f8 ff ff       	jmp    80106144 <alltraps>

801068a0 <vector34>:
.globl vector34
vector34:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $34
801068a2:	6a 22                	push   $0x22
  jmp alltraps
801068a4:	e9 9b f8 ff ff       	jmp    80106144 <alltraps>

801068a9 <vector35>:
.globl vector35
vector35:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $35
801068ab:	6a 23                	push   $0x23
  jmp alltraps
801068ad:	e9 92 f8 ff ff       	jmp    80106144 <alltraps>

801068b2 <vector36>:
.globl vector36
vector36:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $36
801068b4:	6a 24                	push   $0x24
  jmp alltraps
801068b6:	e9 89 f8 ff ff       	jmp    80106144 <alltraps>

801068bb <vector37>:
.globl vector37
vector37:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $37
801068bd:	6a 25                	push   $0x25
  jmp alltraps
801068bf:	e9 80 f8 ff ff       	jmp    80106144 <alltraps>

801068c4 <vector38>:
.globl vector38
vector38:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $38
801068c6:	6a 26                	push   $0x26
  jmp alltraps
801068c8:	e9 77 f8 ff ff       	jmp    80106144 <alltraps>

801068cd <vector39>:
.globl vector39
vector39:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $39
801068cf:	6a 27                	push   $0x27
  jmp alltraps
801068d1:	e9 6e f8 ff ff       	jmp    80106144 <alltraps>

801068d6 <vector40>:
.globl vector40
vector40:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $40
801068d8:	6a 28                	push   $0x28
  jmp alltraps
801068da:	e9 65 f8 ff ff       	jmp    80106144 <alltraps>

801068df <vector41>:
.globl vector41
vector41:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $41
801068e1:	6a 29                	push   $0x29
  jmp alltraps
801068e3:	e9 5c f8 ff ff       	jmp    80106144 <alltraps>

801068e8 <vector42>:
.globl vector42
vector42:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $42
801068ea:	6a 2a                	push   $0x2a
  jmp alltraps
801068ec:	e9 53 f8 ff ff       	jmp    80106144 <alltraps>

801068f1 <vector43>:
.globl vector43
vector43:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $43
801068f3:	6a 2b                	push   $0x2b
  jmp alltraps
801068f5:	e9 4a f8 ff ff       	jmp    80106144 <alltraps>

801068fa <vector44>:
.globl vector44
vector44:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $44
801068fc:	6a 2c                	push   $0x2c
  jmp alltraps
801068fe:	e9 41 f8 ff ff       	jmp    80106144 <alltraps>

80106903 <vector45>:
.globl vector45
vector45:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $45
80106905:	6a 2d                	push   $0x2d
  jmp alltraps
80106907:	e9 38 f8 ff ff       	jmp    80106144 <alltraps>

8010690c <vector46>:
.globl vector46
vector46:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $46
8010690e:	6a 2e                	push   $0x2e
  jmp alltraps
80106910:	e9 2f f8 ff ff       	jmp    80106144 <alltraps>

80106915 <vector47>:
.globl vector47
vector47:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $47
80106917:	6a 2f                	push   $0x2f
  jmp alltraps
80106919:	e9 26 f8 ff ff       	jmp    80106144 <alltraps>

8010691e <vector48>:
.globl vector48
vector48:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $48
80106920:	6a 30                	push   $0x30
  jmp alltraps
80106922:	e9 1d f8 ff ff       	jmp    80106144 <alltraps>

80106927 <vector49>:
.globl vector49
vector49:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $49
80106929:	6a 31                	push   $0x31
  jmp alltraps
8010692b:	e9 14 f8 ff ff       	jmp    80106144 <alltraps>

80106930 <vector50>:
.globl vector50
vector50:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $50
80106932:	6a 32                	push   $0x32
  jmp alltraps
80106934:	e9 0b f8 ff ff       	jmp    80106144 <alltraps>

80106939 <vector51>:
.globl vector51
vector51:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $51
8010693b:	6a 33                	push   $0x33
  jmp alltraps
8010693d:	e9 02 f8 ff ff       	jmp    80106144 <alltraps>

80106942 <vector52>:
.globl vector52
vector52:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $52
80106944:	6a 34                	push   $0x34
  jmp alltraps
80106946:	e9 f9 f7 ff ff       	jmp    80106144 <alltraps>

8010694b <vector53>:
.globl vector53
vector53:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $53
8010694d:	6a 35                	push   $0x35
  jmp alltraps
8010694f:	e9 f0 f7 ff ff       	jmp    80106144 <alltraps>

80106954 <vector54>:
.globl vector54
vector54:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $54
80106956:	6a 36                	push   $0x36
  jmp alltraps
80106958:	e9 e7 f7 ff ff       	jmp    80106144 <alltraps>

8010695d <vector55>:
.globl vector55
vector55:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $55
8010695f:	6a 37                	push   $0x37
  jmp alltraps
80106961:	e9 de f7 ff ff       	jmp    80106144 <alltraps>

80106966 <vector56>:
.globl vector56
vector56:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $56
80106968:	6a 38                	push   $0x38
  jmp alltraps
8010696a:	e9 d5 f7 ff ff       	jmp    80106144 <alltraps>

8010696f <vector57>:
.globl vector57
vector57:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $57
80106971:	6a 39                	push   $0x39
  jmp alltraps
80106973:	e9 cc f7 ff ff       	jmp    80106144 <alltraps>

80106978 <vector58>:
.globl vector58
vector58:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $58
8010697a:	6a 3a                	push   $0x3a
  jmp alltraps
8010697c:	e9 c3 f7 ff ff       	jmp    80106144 <alltraps>

80106981 <vector59>:
.globl vector59
vector59:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $59
80106983:	6a 3b                	push   $0x3b
  jmp alltraps
80106985:	e9 ba f7 ff ff       	jmp    80106144 <alltraps>

8010698a <vector60>:
.globl vector60
vector60:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $60
8010698c:	6a 3c                	push   $0x3c
  jmp alltraps
8010698e:	e9 b1 f7 ff ff       	jmp    80106144 <alltraps>

80106993 <vector61>:
.globl vector61
vector61:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $61
80106995:	6a 3d                	push   $0x3d
  jmp alltraps
80106997:	e9 a8 f7 ff ff       	jmp    80106144 <alltraps>

8010699c <vector62>:
.globl vector62
vector62:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $62
8010699e:	6a 3e                	push   $0x3e
  jmp alltraps
801069a0:	e9 9f f7 ff ff       	jmp    80106144 <alltraps>

801069a5 <vector63>:
.globl vector63
vector63:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $63
801069a7:	6a 3f                	push   $0x3f
  jmp alltraps
801069a9:	e9 96 f7 ff ff       	jmp    80106144 <alltraps>

801069ae <vector64>:
.globl vector64
vector64:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $64
801069b0:	6a 40                	push   $0x40
  jmp alltraps
801069b2:	e9 8d f7 ff ff       	jmp    80106144 <alltraps>

801069b7 <vector65>:
.globl vector65
vector65:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $65
801069b9:	6a 41                	push   $0x41
  jmp alltraps
801069bb:	e9 84 f7 ff ff       	jmp    80106144 <alltraps>

801069c0 <vector66>:
.globl vector66
vector66:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $66
801069c2:	6a 42                	push   $0x42
  jmp alltraps
801069c4:	e9 7b f7 ff ff       	jmp    80106144 <alltraps>

801069c9 <vector67>:
.globl vector67
vector67:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $67
801069cb:	6a 43                	push   $0x43
  jmp alltraps
801069cd:	e9 72 f7 ff ff       	jmp    80106144 <alltraps>

801069d2 <vector68>:
.globl vector68
vector68:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $68
801069d4:	6a 44                	push   $0x44
  jmp alltraps
801069d6:	e9 69 f7 ff ff       	jmp    80106144 <alltraps>

801069db <vector69>:
.globl vector69
vector69:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $69
801069dd:	6a 45                	push   $0x45
  jmp alltraps
801069df:	e9 60 f7 ff ff       	jmp    80106144 <alltraps>

801069e4 <vector70>:
.globl vector70
vector70:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $70
801069e6:	6a 46                	push   $0x46
  jmp alltraps
801069e8:	e9 57 f7 ff ff       	jmp    80106144 <alltraps>

801069ed <vector71>:
.globl vector71
vector71:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $71
801069ef:	6a 47                	push   $0x47
  jmp alltraps
801069f1:	e9 4e f7 ff ff       	jmp    80106144 <alltraps>

801069f6 <vector72>:
.globl vector72
vector72:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $72
801069f8:	6a 48                	push   $0x48
  jmp alltraps
801069fa:	e9 45 f7 ff ff       	jmp    80106144 <alltraps>

801069ff <vector73>:
.globl vector73
vector73:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $73
80106a01:	6a 49                	push   $0x49
  jmp alltraps
80106a03:	e9 3c f7 ff ff       	jmp    80106144 <alltraps>

80106a08 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $74
80106a0a:	6a 4a                	push   $0x4a
  jmp alltraps
80106a0c:	e9 33 f7 ff ff       	jmp    80106144 <alltraps>

80106a11 <vector75>:
.globl vector75
vector75:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $75
80106a13:	6a 4b                	push   $0x4b
  jmp alltraps
80106a15:	e9 2a f7 ff ff       	jmp    80106144 <alltraps>

80106a1a <vector76>:
.globl vector76
vector76:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $76
80106a1c:	6a 4c                	push   $0x4c
  jmp alltraps
80106a1e:	e9 21 f7 ff ff       	jmp    80106144 <alltraps>

80106a23 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $77
80106a25:	6a 4d                	push   $0x4d
  jmp alltraps
80106a27:	e9 18 f7 ff ff       	jmp    80106144 <alltraps>

80106a2c <vector78>:
.globl vector78
vector78:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $78
80106a2e:	6a 4e                	push   $0x4e
  jmp alltraps
80106a30:	e9 0f f7 ff ff       	jmp    80106144 <alltraps>

80106a35 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $79
80106a37:	6a 4f                	push   $0x4f
  jmp alltraps
80106a39:	e9 06 f7 ff ff       	jmp    80106144 <alltraps>

80106a3e <vector80>:
.globl vector80
vector80:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $80
80106a40:	6a 50                	push   $0x50
  jmp alltraps
80106a42:	e9 fd f6 ff ff       	jmp    80106144 <alltraps>

80106a47 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $81
80106a49:	6a 51                	push   $0x51
  jmp alltraps
80106a4b:	e9 f4 f6 ff ff       	jmp    80106144 <alltraps>

80106a50 <vector82>:
.globl vector82
vector82:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $82
80106a52:	6a 52                	push   $0x52
  jmp alltraps
80106a54:	e9 eb f6 ff ff       	jmp    80106144 <alltraps>

80106a59 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $83
80106a5b:	6a 53                	push   $0x53
  jmp alltraps
80106a5d:	e9 e2 f6 ff ff       	jmp    80106144 <alltraps>

80106a62 <vector84>:
.globl vector84
vector84:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $84
80106a64:	6a 54                	push   $0x54
  jmp alltraps
80106a66:	e9 d9 f6 ff ff       	jmp    80106144 <alltraps>

80106a6b <vector85>:
.globl vector85
vector85:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $85
80106a6d:	6a 55                	push   $0x55
  jmp alltraps
80106a6f:	e9 d0 f6 ff ff       	jmp    80106144 <alltraps>

80106a74 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $86
80106a76:	6a 56                	push   $0x56
  jmp alltraps
80106a78:	e9 c7 f6 ff ff       	jmp    80106144 <alltraps>

80106a7d <vector87>:
.globl vector87
vector87:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $87
80106a7f:	6a 57                	push   $0x57
  jmp alltraps
80106a81:	e9 be f6 ff ff       	jmp    80106144 <alltraps>

80106a86 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $88
80106a88:	6a 58                	push   $0x58
  jmp alltraps
80106a8a:	e9 b5 f6 ff ff       	jmp    80106144 <alltraps>

80106a8f <vector89>:
.globl vector89
vector89:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $89
80106a91:	6a 59                	push   $0x59
  jmp alltraps
80106a93:	e9 ac f6 ff ff       	jmp    80106144 <alltraps>

80106a98 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $90
80106a9a:	6a 5a                	push   $0x5a
  jmp alltraps
80106a9c:	e9 a3 f6 ff ff       	jmp    80106144 <alltraps>

80106aa1 <vector91>:
.globl vector91
vector91:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $91
80106aa3:	6a 5b                	push   $0x5b
  jmp alltraps
80106aa5:	e9 9a f6 ff ff       	jmp    80106144 <alltraps>

80106aaa <vector92>:
.globl vector92
vector92:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $92
80106aac:	6a 5c                	push   $0x5c
  jmp alltraps
80106aae:	e9 91 f6 ff ff       	jmp    80106144 <alltraps>

80106ab3 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $93
80106ab5:	6a 5d                	push   $0x5d
  jmp alltraps
80106ab7:	e9 88 f6 ff ff       	jmp    80106144 <alltraps>

80106abc <vector94>:
.globl vector94
vector94:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $94
80106abe:	6a 5e                	push   $0x5e
  jmp alltraps
80106ac0:	e9 7f f6 ff ff       	jmp    80106144 <alltraps>

80106ac5 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $95
80106ac7:	6a 5f                	push   $0x5f
  jmp alltraps
80106ac9:	e9 76 f6 ff ff       	jmp    80106144 <alltraps>

80106ace <vector96>:
.globl vector96
vector96:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $96
80106ad0:	6a 60                	push   $0x60
  jmp alltraps
80106ad2:	e9 6d f6 ff ff       	jmp    80106144 <alltraps>

80106ad7 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $97
80106ad9:	6a 61                	push   $0x61
  jmp alltraps
80106adb:	e9 64 f6 ff ff       	jmp    80106144 <alltraps>

80106ae0 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $98
80106ae2:	6a 62                	push   $0x62
  jmp alltraps
80106ae4:	e9 5b f6 ff ff       	jmp    80106144 <alltraps>

80106ae9 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $99
80106aeb:	6a 63                	push   $0x63
  jmp alltraps
80106aed:	e9 52 f6 ff ff       	jmp    80106144 <alltraps>

80106af2 <vector100>:
.globl vector100
vector100:
  pushl $0
80106af2:	6a 00                	push   $0x0
  pushl $100
80106af4:	6a 64                	push   $0x64
  jmp alltraps
80106af6:	e9 49 f6 ff ff       	jmp    80106144 <alltraps>

80106afb <vector101>:
.globl vector101
vector101:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $101
80106afd:	6a 65                	push   $0x65
  jmp alltraps
80106aff:	e9 40 f6 ff ff       	jmp    80106144 <alltraps>

80106b04 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b04:	6a 00                	push   $0x0
  pushl $102
80106b06:	6a 66                	push   $0x66
  jmp alltraps
80106b08:	e9 37 f6 ff ff       	jmp    80106144 <alltraps>

80106b0d <vector103>:
.globl vector103
vector103:
  pushl $0
80106b0d:	6a 00                	push   $0x0
  pushl $103
80106b0f:	6a 67                	push   $0x67
  jmp alltraps
80106b11:	e9 2e f6 ff ff       	jmp    80106144 <alltraps>

80106b16 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b16:	6a 00                	push   $0x0
  pushl $104
80106b18:	6a 68                	push   $0x68
  jmp alltraps
80106b1a:	e9 25 f6 ff ff       	jmp    80106144 <alltraps>

80106b1f <vector105>:
.globl vector105
vector105:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $105
80106b21:	6a 69                	push   $0x69
  jmp alltraps
80106b23:	e9 1c f6 ff ff       	jmp    80106144 <alltraps>

80106b28 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $106
80106b2a:	6a 6a                	push   $0x6a
  jmp alltraps
80106b2c:	e9 13 f6 ff ff       	jmp    80106144 <alltraps>

80106b31 <vector107>:
.globl vector107
vector107:
  pushl $0
80106b31:	6a 00                	push   $0x0
  pushl $107
80106b33:	6a 6b                	push   $0x6b
  jmp alltraps
80106b35:	e9 0a f6 ff ff       	jmp    80106144 <alltraps>

80106b3a <vector108>:
.globl vector108
vector108:
  pushl $0
80106b3a:	6a 00                	push   $0x0
  pushl $108
80106b3c:	6a 6c                	push   $0x6c
  jmp alltraps
80106b3e:	e9 01 f6 ff ff       	jmp    80106144 <alltraps>

80106b43 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $109
80106b45:	6a 6d                	push   $0x6d
  jmp alltraps
80106b47:	e9 f8 f5 ff ff       	jmp    80106144 <alltraps>

80106b4c <vector110>:
.globl vector110
vector110:
  pushl $0
80106b4c:	6a 00                	push   $0x0
  pushl $110
80106b4e:	6a 6e                	push   $0x6e
  jmp alltraps
80106b50:	e9 ef f5 ff ff       	jmp    80106144 <alltraps>

80106b55 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b55:	6a 00                	push   $0x0
  pushl $111
80106b57:	6a 6f                	push   $0x6f
  jmp alltraps
80106b59:	e9 e6 f5 ff ff       	jmp    80106144 <alltraps>

80106b5e <vector112>:
.globl vector112
vector112:
  pushl $0
80106b5e:	6a 00                	push   $0x0
  pushl $112
80106b60:	6a 70                	push   $0x70
  jmp alltraps
80106b62:	e9 dd f5 ff ff       	jmp    80106144 <alltraps>

80106b67 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $113
80106b69:	6a 71                	push   $0x71
  jmp alltraps
80106b6b:	e9 d4 f5 ff ff       	jmp    80106144 <alltraps>

80106b70 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b70:	6a 00                	push   $0x0
  pushl $114
80106b72:	6a 72                	push   $0x72
  jmp alltraps
80106b74:	e9 cb f5 ff ff       	jmp    80106144 <alltraps>

80106b79 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $115
80106b7b:	6a 73                	push   $0x73
  jmp alltraps
80106b7d:	e9 c2 f5 ff ff       	jmp    80106144 <alltraps>

80106b82 <vector116>:
.globl vector116
vector116:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $116
80106b84:	6a 74                	push   $0x74
  jmp alltraps
80106b86:	e9 b9 f5 ff ff       	jmp    80106144 <alltraps>

80106b8b <vector117>:
.globl vector117
vector117:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $117
80106b8d:	6a 75                	push   $0x75
  jmp alltraps
80106b8f:	e9 b0 f5 ff ff       	jmp    80106144 <alltraps>

80106b94 <vector118>:
.globl vector118
vector118:
  pushl $0
80106b94:	6a 00                	push   $0x0
  pushl $118
80106b96:	6a 76                	push   $0x76
  jmp alltraps
80106b98:	e9 a7 f5 ff ff       	jmp    80106144 <alltraps>

80106b9d <vector119>:
.globl vector119
vector119:
  pushl $0
80106b9d:	6a 00                	push   $0x0
  pushl $119
80106b9f:	6a 77                	push   $0x77
  jmp alltraps
80106ba1:	e9 9e f5 ff ff       	jmp    80106144 <alltraps>

80106ba6 <vector120>:
.globl vector120
vector120:
  pushl $0
80106ba6:	6a 00                	push   $0x0
  pushl $120
80106ba8:	6a 78                	push   $0x78
  jmp alltraps
80106baa:	e9 95 f5 ff ff       	jmp    80106144 <alltraps>

80106baf <vector121>:
.globl vector121
vector121:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $121
80106bb1:	6a 79                	push   $0x79
  jmp alltraps
80106bb3:	e9 8c f5 ff ff       	jmp    80106144 <alltraps>

80106bb8 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bb8:	6a 00                	push   $0x0
  pushl $122
80106bba:	6a 7a                	push   $0x7a
  jmp alltraps
80106bbc:	e9 83 f5 ff ff       	jmp    80106144 <alltraps>

80106bc1 <vector123>:
.globl vector123
vector123:
  pushl $0
80106bc1:	6a 00                	push   $0x0
  pushl $123
80106bc3:	6a 7b                	push   $0x7b
  jmp alltraps
80106bc5:	e9 7a f5 ff ff       	jmp    80106144 <alltraps>

80106bca <vector124>:
.globl vector124
vector124:
  pushl $0
80106bca:	6a 00                	push   $0x0
  pushl $124
80106bcc:	6a 7c                	push   $0x7c
  jmp alltraps
80106bce:	e9 71 f5 ff ff       	jmp    80106144 <alltraps>

80106bd3 <vector125>:
.globl vector125
vector125:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $125
80106bd5:	6a 7d                	push   $0x7d
  jmp alltraps
80106bd7:	e9 68 f5 ff ff       	jmp    80106144 <alltraps>

80106bdc <vector126>:
.globl vector126
vector126:
  pushl $0
80106bdc:	6a 00                	push   $0x0
  pushl $126
80106bde:	6a 7e                	push   $0x7e
  jmp alltraps
80106be0:	e9 5f f5 ff ff       	jmp    80106144 <alltraps>

80106be5 <vector127>:
.globl vector127
vector127:
  pushl $0
80106be5:	6a 00                	push   $0x0
  pushl $127
80106be7:	6a 7f                	push   $0x7f
  jmp alltraps
80106be9:	e9 56 f5 ff ff       	jmp    80106144 <alltraps>

80106bee <vector128>:
.globl vector128
vector128:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $128
80106bf0:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bf5:	e9 4a f5 ff ff       	jmp    80106144 <alltraps>

80106bfa <vector129>:
.globl vector129
vector129:
  pushl $0
80106bfa:	6a 00                	push   $0x0
  pushl $129
80106bfc:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c01:	e9 3e f5 ff ff       	jmp    80106144 <alltraps>

80106c06 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c06:	6a 00                	push   $0x0
  pushl $130
80106c08:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c0d:	e9 32 f5 ff ff       	jmp    80106144 <alltraps>

80106c12 <vector131>:
.globl vector131
vector131:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $131
80106c14:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c19:	e9 26 f5 ff ff       	jmp    80106144 <alltraps>

80106c1e <vector132>:
.globl vector132
vector132:
  pushl $0
80106c1e:	6a 00                	push   $0x0
  pushl $132
80106c20:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c25:	e9 1a f5 ff ff       	jmp    80106144 <alltraps>

80106c2a <vector133>:
.globl vector133
vector133:
  pushl $0
80106c2a:	6a 00                	push   $0x0
  pushl $133
80106c2c:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c31:	e9 0e f5 ff ff       	jmp    80106144 <alltraps>

80106c36 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c36:	6a 00                	push   $0x0
  pushl $134
80106c38:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c3d:	e9 02 f5 ff ff       	jmp    80106144 <alltraps>

80106c42 <vector135>:
.globl vector135
vector135:
  pushl $0
80106c42:	6a 00                	push   $0x0
  pushl $135
80106c44:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c49:	e9 f6 f4 ff ff       	jmp    80106144 <alltraps>

80106c4e <vector136>:
.globl vector136
vector136:
  pushl $0
80106c4e:	6a 00                	push   $0x0
  pushl $136
80106c50:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c55:	e9 ea f4 ff ff       	jmp    80106144 <alltraps>

80106c5a <vector137>:
.globl vector137
vector137:
  pushl $0
80106c5a:	6a 00                	push   $0x0
  pushl $137
80106c5c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c61:	e9 de f4 ff ff       	jmp    80106144 <alltraps>

80106c66 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c66:	6a 00                	push   $0x0
  pushl $138
80106c68:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c6d:	e9 d2 f4 ff ff       	jmp    80106144 <alltraps>

80106c72 <vector139>:
.globl vector139
vector139:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $139
80106c74:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c79:	e9 c6 f4 ff ff       	jmp    80106144 <alltraps>

80106c7e <vector140>:
.globl vector140
vector140:
  pushl $0
80106c7e:	6a 00                	push   $0x0
  pushl $140
80106c80:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c85:	e9 ba f4 ff ff       	jmp    80106144 <alltraps>

80106c8a <vector141>:
.globl vector141
vector141:
  pushl $0
80106c8a:	6a 00                	push   $0x0
  pushl $141
80106c8c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c91:	e9 ae f4 ff ff       	jmp    80106144 <alltraps>

80106c96 <vector142>:
.globl vector142
vector142:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $142
80106c98:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c9d:	e9 a2 f4 ff ff       	jmp    80106144 <alltraps>

80106ca2 <vector143>:
.globl vector143
vector143:
  pushl $0
80106ca2:	6a 00                	push   $0x0
  pushl $143
80106ca4:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ca9:	e9 96 f4 ff ff       	jmp    80106144 <alltraps>

80106cae <vector144>:
.globl vector144
vector144:
  pushl $0
80106cae:	6a 00                	push   $0x0
  pushl $144
80106cb0:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106cb5:	e9 8a f4 ff ff       	jmp    80106144 <alltraps>

80106cba <vector145>:
.globl vector145
vector145:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $145
80106cbc:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cc1:	e9 7e f4 ff ff       	jmp    80106144 <alltraps>

80106cc6 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cc6:	6a 00                	push   $0x0
  pushl $146
80106cc8:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ccd:	e9 72 f4 ff ff       	jmp    80106144 <alltraps>

80106cd2 <vector147>:
.globl vector147
vector147:
  pushl $0
80106cd2:	6a 00                	push   $0x0
  pushl $147
80106cd4:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cd9:	e9 66 f4 ff ff       	jmp    80106144 <alltraps>

80106cde <vector148>:
.globl vector148
vector148:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $148
80106ce0:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ce5:	e9 5a f4 ff ff       	jmp    80106144 <alltraps>

80106cea <vector149>:
.globl vector149
vector149:
  pushl $0
80106cea:	6a 00                	push   $0x0
  pushl $149
80106cec:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cf1:	e9 4e f4 ff ff       	jmp    80106144 <alltraps>

80106cf6 <vector150>:
.globl vector150
vector150:
  pushl $0
80106cf6:	6a 00                	push   $0x0
  pushl $150
80106cf8:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cfd:	e9 42 f4 ff ff       	jmp    80106144 <alltraps>

80106d02 <vector151>:
.globl vector151
vector151:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $151
80106d04:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d09:	e9 36 f4 ff ff       	jmp    80106144 <alltraps>

80106d0e <vector152>:
.globl vector152
vector152:
  pushl $0
80106d0e:	6a 00                	push   $0x0
  pushl $152
80106d10:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d15:	e9 2a f4 ff ff       	jmp    80106144 <alltraps>

80106d1a <vector153>:
.globl vector153
vector153:
  pushl $0
80106d1a:	6a 00                	push   $0x0
  pushl $153
80106d1c:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d21:	e9 1e f4 ff ff       	jmp    80106144 <alltraps>

80106d26 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $154
80106d28:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d2d:	e9 12 f4 ff ff       	jmp    80106144 <alltraps>

80106d32 <vector155>:
.globl vector155
vector155:
  pushl $0
80106d32:	6a 00                	push   $0x0
  pushl $155
80106d34:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d39:	e9 06 f4 ff ff       	jmp    80106144 <alltraps>

80106d3e <vector156>:
.globl vector156
vector156:
  pushl $0
80106d3e:	6a 00                	push   $0x0
  pushl $156
80106d40:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d45:	e9 fa f3 ff ff       	jmp    80106144 <alltraps>

80106d4a <vector157>:
.globl vector157
vector157:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $157
80106d4c:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d51:	e9 ee f3 ff ff       	jmp    80106144 <alltraps>

80106d56 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d56:	6a 00                	push   $0x0
  pushl $158
80106d58:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d5d:	e9 e2 f3 ff ff       	jmp    80106144 <alltraps>

80106d62 <vector159>:
.globl vector159
vector159:
  pushl $0
80106d62:	6a 00                	push   $0x0
  pushl $159
80106d64:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d69:	e9 d6 f3 ff ff       	jmp    80106144 <alltraps>

80106d6e <vector160>:
.globl vector160
vector160:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $160
80106d70:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d75:	e9 ca f3 ff ff       	jmp    80106144 <alltraps>

80106d7a <vector161>:
.globl vector161
vector161:
  pushl $0
80106d7a:	6a 00                	push   $0x0
  pushl $161
80106d7c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d81:	e9 be f3 ff ff       	jmp    80106144 <alltraps>

80106d86 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d86:	6a 00                	push   $0x0
  pushl $162
80106d88:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d8d:	e9 b2 f3 ff ff       	jmp    80106144 <alltraps>

80106d92 <vector163>:
.globl vector163
vector163:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $163
80106d94:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d99:	e9 a6 f3 ff ff       	jmp    80106144 <alltraps>

80106d9e <vector164>:
.globl vector164
vector164:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $164
80106da0:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106da5:	e9 9a f3 ff ff       	jmp    80106144 <alltraps>

80106daa <vector165>:
.globl vector165
vector165:
  pushl $0
80106daa:	6a 00                	push   $0x0
  pushl $165
80106dac:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106db1:	e9 8e f3 ff ff       	jmp    80106144 <alltraps>

80106db6 <vector166>:
.globl vector166
vector166:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $166
80106db8:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dbd:	e9 82 f3 ff ff       	jmp    80106144 <alltraps>

80106dc2 <vector167>:
.globl vector167
vector167:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $167
80106dc4:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106dc9:	e9 76 f3 ff ff       	jmp    80106144 <alltraps>

80106dce <vector168>:
.globl vector168
vector168:
  pushl $0
80106dce:	6a 00                	push   $0x0
  pushl $168
80106dd0:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106dd5:	e9 6a f3 ff ff       	jmp    80106144 <alltraps>

80106dda <vector169>:
.globl vector169
vector169:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $169
80106ddc:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106de1:	e9 5e f3 ff ff       	jmp    80106144 <alltraps>

80106de6 <vector170>:
.globl vector170
vector170:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $170
80106de8:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ded:	e9 52 f3 ff ff       	jmp    80106144 <alltraps>

80106df2 <vector171>:
.globl vector171
vector171:
  pushl $0
80106df2:	6a 00                	push   $0x0
  pushl $171
80106df4:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106df9:	e9 46 f3 ff ff       	jmp    80106144 <alltraps>

80106dfe <vector172>:
.globl vector172
vector172:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $172
80106e00:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e05:	e9 3a f3 ff ff       	jmp    80106144 <alltraps>

80106e0a <vector173>:
.globl vector173
vector173:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $173
80106e0c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e11:	e9 2e f3 ff ff       	jmp    80106144 <alltraps>

80106e16 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e16:	6a 00                	push   $0x0
  pushl $174
80106e18:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e1d:	e9 22 f3 ff ff       	jmp    80106144 <alltraps>

80106e22 <vector175>:
.globl vector175
vector175:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $175
80106e24:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e29:	e9 16 f3 ff ff       	jmp    80106144 <alltraps>

80106e2e <vector176>:
.globl vector176
vector176:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $176
80106e30:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e35:	e9 0a f3 ff ff       	jmp    80106144 <alltraps>

80106e3a <vector177>:
.globl vector177
vector177:
  pushl $0
80106e3a:	6a 00                	push   $0x0
  pushl $177
80106e3c:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e41:	e9 fe f2 ff ff       	jmp    80106144 <alltraps>

80106e46 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $178
80106e48:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e4d:	e9 f2 f2 ff ff       	jmp    80106144 <alltraps>

80106e52 <vector179>:
.globl vector179
vector179:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $179
80106e54:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e59:	e9 e6 f2 ff ff       	jmp    80106144 <alltraps>

80106e5e <vector180>:
.globl vector180
vector180:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $180
80106e60:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e65:	e9 da f2 ff ff       	jmp    80106144 <alltraps>

80106e6a <vector181>:
.globl vector181
vector181:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $181
80106e6c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e71:	e9 ce f2 ff ff       	jmp    80106144 <alltraps>

80106e76 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $182
80106e78:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e7d:	e9 c2 f2 ff ff       	jmp    80106144 <alltraps>

80106e82 <vector183>:
.globl vector183
vector183:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $183
80106e84:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e89:	e9 b6 f2 ff ff       	jmp    80106144 <alltraps>

80106e8e <vector184>:
.globl vector184
vector184:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $184
80106e90:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e95:	e9 aa f2 ff ff       	jmp    80106144 <alltraps>

80106e9a <vector185>:
.globl vector185
vector185:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $185
80106e9c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ea1:	e9 9e f2 ff ff       	jmp    80106144 <alltraps>

80106ea6 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ea6:	6a 00                	push   $0x0
  pushl $186
80106ea8:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ead:	e9 92 f2 ff ff       	jmp    80106144 <alltraps>

80106eb2 <vector187>:
.globl vector187
vector187:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $187
80106eb4:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106eb9:	e9 86 f2 ff ff       	jmp    80106144 <alltraps>

80106ebe <vector188>:
.globl vector188
vector188:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $188
80106ec0:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ec5:	e9 7a f2 ff ff       	jmp    80106144 <alltraps>

80106eca <vector189>:
.globl vector189
vector189:
  pushl $0
80106eca:	6a 00                	push   $0x0
  pushl $189
80106ecc:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ed1:	e9 6e f2 ff ff       	jmp    80106144 <alltraps>

80106ed6 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $190
80106ed8:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106edd:	e9 62 f2 ff ff       	jmp    80106144 <alltraps>

80106ee2 <vector191>:
.globl vector191
vector191:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $191
80106ee4:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ee9:	e9 56 f2 ff ff       	jmp    80106144 <alltraps>

80106eee <vector192>:
.globl vector192
vector192:
  pushl $0
80106eee:	6a 00                	push   $0x0
  pushl $192
80106ef0:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ef5:	e9 4a f2 ff ff       	jmp    80106144 <alltraps>

80106efa <vector193>:
.globl vector193
vector193:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $193
80106efc:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f01:	e9 3e f2 ff ff       	jmp    80106144 <alltraps>

80106f06 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $194
80106f08:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f0d:	e9 32 f2 ff ff       	jmp    80106144 <alltraps>

80106f12 <vector195>:
.globl vector195
vector195:
  pushl $0
80106f12:	6a 00                	push   $0x0
  pushl $195
80106f14:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f19:	e9 26 f2 ff ff       	jmp    80106144 <alltraps>

80106f1e <vector196>:
.globl vector196
vector196:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $196
80106f20:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f25:	e9 1a f2 ff ff       	jmp    80106144 <alltraps>

80106f2a <vector197>:
.globl vector197
vector197:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $197
80106f2c:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f31:	e9 0e f2 ff ff       	jmp    80106144 <alltraps>

80106f36 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f36:	6a 00                	push   $0x0
  pushl $198
80106f38:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f3d:	e9 02 f2 ff ff       	jmp    80106144 <alltraps>

80106f42 <vector199>:
.globl vector199
vector199:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $199
80106f44:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f49:	e9 f6 f1 ff ff       	jmp    80106144 <alltraps>

80106f4e <vector200>:
.globl vector200
vector200:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $200
80106f50:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f55:	e9 ea f1 ff ff       	jmp    80106144 <alltraps>

80106f5a <vector201>:
.globl vector201
vector201:
  pushl $0
80106f5a:	6a 00                	push   $0x0
  pushl $201
80106f5c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f61:	e9 de f1 ff ff       	jmp    80106144 <alltraps>

80106f66 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $202
80106f68:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f6d:	e9 d2 f1 ff ff       	jmp    80106144 <alltraps>

80106f72 <vector203>:
.globl vector203
vector203:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $203
80106f74:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f79:	e9 c6 f1 ff ff       	jmp    80106144 <alltraps>

80106f7e <vector204>:
.globl vector204
vector204:
  pushl $0
80106f7e:	6a 00                	push   $0x0
  pushl $204
80106f80:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f85:	e9 ba f1 ff ff       	jmp    80106144 <alltraps>

80106f8a <vector205>:
.globl vector205
vector205:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $205
80106f8c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f91:	e9 ae f1 ff ff       	jmp    80106144 <alltraps>

80106f96 <vector206>:
.globl vector206
vector206:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $206
80106f98:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f9d:	e9 a2 f1 ff ff       	jmp    80106144 <alltraps>

80106fa2 <vector207>:
.globl vector207
vector207:
  pushl $0
80106fa2:	6a 00                	push   $0x0
  pushl $207
80106fa4:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fa9:	e9 96 f1 ff ff       	jmp    80106144 <alltraps>

80106fae <vector208>:
.globl vector208
vector208:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $208
80106fb0:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fb5:	e9 8a f1 ff ff       	jmp    80106144 <alltraps>

80106fba <vector209>:
.globl vector209
vector209:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $209
80106fbc:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fc1:	e9 7e f1 ff ff       	jmp    80106144 <alltraps>

80106fc6 <vector210>:
.globl vector210
vector210:
  pushl $0
80106fc6:	6a 00                	push   $0x0
  pushl $210
80106fc8:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fcd:	e9 72 f1 ff ff       	jmp    80106144 <alltraps>

80106fd2 <vector211>:
.globl vector211
vector211:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $211
80106fd4:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fd9:	e9 66 f1 ff ff       	jmp    80106144 <alltraps>

80106fde <vector212>:
.globl vector212
vector212:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $212
80106fe0:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fe5:	e9 5a f1 ff ff       	jmp    80106144 <alltraps>

80106fea <vector213>:
.globl vector213
vector213:
  pushl $0
80106fea:	6a 00                	push   $0x0
  pushl $213
80106fec:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106ff1:	e9 4e f1 ff ff       	jmp    80106144 <alltraps>

80106ff6 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $214
80106ff8:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ffd:	e9 42 f1 ff ff       	jmp    80106144 <alltraps>

80107002 <vector215>:
.globl vector215
vector215:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $215
80107004:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107009:	e9 36 f1 ff ff       	jmp    80106144 <alltraps>

8010700e <vector216>:
.globl vector216
vector216:
  pushl $0
8010700e:	6a 00                	push   $0x0
  pushl $216
80107010:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107015:	e9 2a f1 ff ff       	jmp    80106144 <alltraps>

8010701a <vector217>:
.globl vector217
vector217:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $217
8010701c:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107021:	e9 1e f1 ff ff       	jmp    80106144 <alltraps>

80107026 <vector218>:
.globl vector218
vector218:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $218
80107028:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010702d:	e9 12 f1 ff ff       	jmp    80106144 <alltraps>

80107032 <vector219>:
.globl vector219
vector219:
  pushl $0
80107032:	6a 00                	push   $0x0
  pushl $219
80107034:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107039:	e9 06 f1 ff ff       	jmp    80106144 <alltraps>

8010703e <vector220>:
.globl vector220
vector220:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $220
80107040:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107045:	e9 fa f0 ff ff       	jmp    80106144 <alltraps>

8010704a <vector221>:
.globl vector221
vector221:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $221
8010704c:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107051:	e9 ee f0 ff ff       	jmp    80106144 <alltraps>

80107056 <vector222>:
.globl vector222
vector222:
  pushl $0
80107056:	6a 00                	push   $0x0
  pushl $222
80107058:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010705d:	e9 e2 f0 ff ff       	jmp    80106144 <alltraps>

80107062 <vector223>:
.globl vector223
vector223:
  pushl $0
80107062:	6a 00                	push   $0x0
  pushl $223
80107064:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107069:	e9 d6 f0 ff ff       	jmp    80106144 <alltraps>

8010706e <vector224>:
.globl vector224
vector224:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $224
80107070:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107075:	e9 ca f0 ff ff       	jmp    80106144 <alltraps>

8010707a <vector225>:
.globl vector225
vector225:
  pushl $0
8010707a:	6a 00                	push   $0x0
  pushl $225
8010707c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107081:	e9 be f0 ff ff       	jmp    80106144 <alltraps>

80107086 <vector226>:
.globl vector226
vector226:
  pushl $0
80107086:	6a 00                	push   $0x0
  pushl $226
80107088:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010708d:	e9 b2 f0 ff ff       	jmp    80106144 <alltraps>

80107092 <vector227>:
.globl vector227
vector227:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $227
80107094:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107099:	e9 a6 f0 ff ff       	jmp    80106144 <alltraps>

8010709e <vector228>:
.globl vector228
vector228:
  pushl $0
8010709e:	6a 00                	push   $0x0
  pushl $228
801070a0:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070a5:	e9 9a f0 ff ff       	jmp    80106144 <alltraps>

801070aa <vector229>:
.globl vector229
vector229:
  pushl $0
801070aa:	6a 00                	push   $0x0
  pushl $229
801070ac:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070b1:	e9 8e f0 ff ff       	jmp    80106144 <alltraps>

801070b6 <vector230>:
.globl vector230
vector230:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $230
801070b8:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070bd:	e9 82 f0 ff ff       	jmp    80106144 <alltraps>

801070c2 <vector231>:
.globl vector231
vector231:
  pushl $0
801070c2:	6a 00                	push   $0x0
  pushl $231
801070c4:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070c9:	e9 76 f0 ff ff       	jmp    80106144 <alltraps>

801070ce <vector232>:
.globl vector232
vector232:
  pushl $0
801070ce:	6a 00                	push   $0x0
  pushl $232
801070d0:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070d5:	e9 6a f0 ff ff       	jmp    80106144 <alltraps>

801070da <vector233>:
.globl vector233
vector233:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $233
801070dc:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070e1:	e9 5e f0 ff ff       	jmp    80106144 <alltraps>

801070e6 <vector234>:
.globl vector234
vector234:
  pushl $0
801070e6:	6a 00                	push   $0x0
  pushl $234
801070e8:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070ed:	e9 52 f0 ff ff       	jmp    80106144 <alltraps>

801070f2 <vector235>:
.globl vector235
vector235:
  pushl $0
801070f2:	6a 00                	push   $0x0
  pushl $235
801070f4:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070f9:	e9 46 f0 ff ff       	jmp    80106144 <alltraps>

801070fe <vector236>:
.globl vector236
vector236:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $236
80107100:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107105:	e9 3a f0 ff ff       	jmp    80106144 <alltraps>

8010710a <vector237>:
.globl vector237
vector237:
  pushl $0
8010710a:	6a 00                	push   $0x0
  pushl $237
8010710c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107111:	e9 2e f0 ff ff       	jmp    80106144 <alltraps>

80107116 <vector238>:
.globl vector238
vector238:
  pushl $0
80107116:	6a 00                	push   $0x0
  pushl $238
80107118:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010711d:	e9 22 f0 ff ff       	jmp    80106144 <alltraps>

80107122 <vector239>:
.globl vector239
vector239:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $239
80107124:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107129:	e9 16 f0 ff ff       	jmp    80106144 <alltraps>

8010712e <vector240>:
.globl vector240
vector240:
  pushl $0
8010712e:	6a 00                	push   $0x0
  pushl $240
80107130:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107135:	e9 0a f0 ff ff       	jmp    80106144 <alltraps>

8010713a <vector241>:
.globl vector241
vector241:
  pushl $0
8010713a:	6a 00                	push   $0x0
  pushl $241
8010713c:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107141:	e9 fe ef ff ff       	jmp    80106144 <alltraps>

80107146 <vector242>:
.globl vector242
vector242:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $242
80107148:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010714d:	e9 f2 ef ff ff       	jmp    80106144 <alltraps>

80107152 <vector243>:
.globl vector243
vector243:
  pushl $0
80107152:	6a 00                	push   $0x0
  pushl $243
80107154:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107159:	e9 e6 ef ff ff       	jmp    80106144 <alltraps>

8010715e <vector244>:
.globl vector244
vector244:
  pushl $0
8010715e:	6a 00                	push   $0x0
  pushl $244
80107160:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107165:	e9 da ef ff ff       	jmp    80106144 <alltraps>

8010716a <vector245>:
.globl vector245
vector245:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $245
8010716c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107171:	e9 ce ef ff ff       	jmp    80106144 <alltraps>

80107176 <vector246>:
.globl vector246
vector246:
  pushl $0
80107176:	6a 00                	push   $0x0
  pushl $246
80107178:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010717d:	e9 c2 ef ff ff       	jmp    80106144 <alltraps>

80107182 <vector247>:
.globl vector247
vector247:
  pushl $0
80107182:	6a 00                	push   $0x0
  pushl $247
80107184:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107189:	e9 b6 ef ff ff       	jmp    80106144 <alltraps>

8010718e <vector248>:
.globl vector248
vector248:
  pushl $0
8010718e:	6a 00                	push   $0x0
  pushl $248
80107190:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107195:	e9 aa ef ff ff       	jmp    80106144 <alltraps>

8010719a <vector249>:
.globl vector249
vector249:
  pushl $0
8010719a:	6a 00                	push   $0x0
  pushl $249
8010719c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071a1:	e9 9e ef ff ff       	jmp    80106144 <alltraps>

801071a6 <vector250>:
.globl vector250
vector250:
  pushl $0
801071a6:	6a 00                	push   $0x0
  pushl $250
801071a8:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071ad:	e9 92 ef ff ff       	jmp    80106144 <alltraps>

801071b2 <vector251>:
.globl vector251
vector251:
  pushl $0
801071b2:	6a 00                	push   $0x0
  pushl $251
801071b4:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071b9:	e9 86 ef ff ff       	jmp    80106144 <alltraps>

801071be <vector252>:
.globl vector252
vector252:
  pushl $0
801071be:	6a 00                	push   $0x0
  pushl $252
801071c0:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071c5:	e9 7a ef ff ff       	jmp    80106144 <alltraps>

801071ca <vector253>:
.globl vector253
vector253:
  pushl $0
801071ca:	6a 00                	push   $0x0
  pushl $253
801071cc:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071d1:	e9 6e ef ff ff       	jmp    80106144 <alltraps>

801071d6 <vector254>:
.globl vector254
vector254:
  pushl $0
801071d6:	6a 00                	push   $0x0
  pushl $254
801071d8:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071dd:	e9 62 ef ff ff       	jmp    80106144 <alltraps>

801071e2 <vector255>:
.globl vector255
vector255:
  pushl $0
801071e2:	6a 00                	push   $0x0
  pushl $255
801071e4:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071e9:	e9 56 ef ff ff       	jmp    80106144 <alltraps>
	...

801071f0 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801071f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801071f9:	48                   	dec    %eax
801071fa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801071fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107201:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107205:	8b 45 08             	mov    0x8(%ebp),%eax
80107208:	c1 e8 10             	shr    $0x10,%eax
8010720b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010720f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107212:	0f 01 10             	lgdtl  (%eax)
}
80107215:	c9                   	leave  
80107216:	c3                   	ret    

80107217 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107217:	55                   	push   %ebp
80107218:	89 e5                	mov    %esp,%ebp
8010721a:	83 ec 04             	sub    $0x4,%esp
8010721d:	8b 45 08             	mov    0x8(%ebp),%eax
80107220:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107224:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107227:	0f 00 d8             	ltr    %ax
}
8010722a:	c9                   	leave  
8010722b:	c3                   	ret    

8010722c <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010722c:	55                   	push   %ebp
8010722d:	89 e5                	mov    %esp,%ebp
8010722f:	83 ec 04             	sub    $0x4,%esp
80107232:	8b 45 08             	mov    0x8(%ebp),%eax
80107235:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107239:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010723c:	8e e8                	mov    %eax,%gs
}
8010723e:	c9                   	leave  
8010723f:	c3                   	ret    

80107240 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107243:	8b 45 08             	mov    0x8(%ebp),%eax
80107246:	0f 22 d8             	mov    %eax,%cr3
}
80107249:	c9                   	leave  
8010724a:	c3                   	ret    

8010724b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010724b:	55                   	push   %ebp
8010724c:	89 e5                	mov    %esp,%ebp
8010724e:	8b 45 08             	mov    0x8(%ebp),%eax
80107251:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107256:	c9                   	leave  
80107257:	c3                   	ret    

80107258 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107258:	55                   	push   %ebp
80107259:	89 e5                	mov    %esp,%ebp
8010725b:	8b 45 08             	mov    0x8(%ebp),%eax
8010725e:	2d 00 00 00 80       	sub    $0x80000000,%eax
80107263:	c9                   	leave  
80107264:	c3                   	ret    

80107265 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107265:	55                   	push   %ebp
80107266:	89 e5                	mov    %esp,%ebp
80107268:	53                   	push   %ebx
80107269:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010726c:	e8 26 bc ff ff       	call   80102e97 <cpunum>
80107271:	89 c2                	mov    %eax,%edx
80107273:	89 d0                	mov    %edx,%eax
80107275:	d1 e0                	shl    %eax
80107277:	01 d0                	add    %edx,%eax
80107279:	c1 e0 04             	shl    $0x4,%eax
8010727c:	29 d0                	sub    %edx,%eax
8010727e:	c1 e0 02             	shl    $0x2,%eax
80107281:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010728c:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107295:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010729b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801072a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a5:	8a 50 7d             	mov    0x7d(%eax),%dl
801072a8:	83 e2 f0             	and    $0xfffffff0,%edx
801072ab:	83 ca 0a             	or     $0xa,%edx
801072ae:	88 50 7d             	mov    %dl,0x7d(%eax)
801072b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072b4:	8a 50 7d             	mov    0x7d(%eax),%dl
801072b7:	83 ca 10             	or     $0x10,%edx
801072ba:	88 50 7d             	mov    %dl,0x7d(%eax)
801072bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c0:	8a 50 7d             	mov    0x7d(%eax),%dl
801072c3:	83 e2 9f             	and    $0xffffff9f,%edx
801072c6:	88 50 7d             	mov    %dl,0x7d(%eax)
801072c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cc:	8a 50 7d             	mov    0x7d(%eax),%dl
801072cf:	83 ca 80             	or     $0xffffff80,%edx
801072d2:	88 50 7d             	mov    %dl,0x7d(%eax)
801072d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d8:	8a 50 7e             	mov    0x7e(%eax),%dl
801072db:	83 ca 0f             	or     $0xf,%edx
801072de:	88 50 7e             	mov    %dl,0x7e(%eax)
801072e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072e4:	8a 50 7e             	mov    0x7e(%eax),%dl
801072e7:	83 e2 ef             	and    $0xffffffef,%edx
801072ea:	88 50 7e             	mov    %dl,0x7e(%eax)
801072ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072f0:	8a 50 7e             	mov    0x7e(%eax),%dl
801072f3:	83 e2 df             	and    $0xffffffdf,%edx
801072f6:	88 50 7e             	mov    %dl,0x7e(%eax)
801072f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072fc:	8a 50 7e             	mov    0x7e(%eax),%dl
801072ff:	83 ca 40             	or     $0x40,%edx
80107302:	88 50 7e             	mov    %dl,0x7e(%eax)
80107305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107308:	8a 50 7e             	mov    0x7e(%eax),%dl
8010730b:	83 ca 80             	or     $0xffffff80,%edx
8010730e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107314:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010731b:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107322:	ff ff 
80107324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107327:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010732e:	00 00 
80107330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107333:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010733a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733d:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107343:	83 e2 f0             	and    $0xfffffff0,%edx
80107346:	83 ca 02             	or     $0x2,%edx
80107349:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010734f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107352:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107358:	83 ca 10             	or     $0x10,%edx
8010735b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107364:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010736a:	83 e2 9f             	and    $0xffffff9f,%edx
8010736d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107376:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010737c:	83 ca 80             	or     $0xffffff80,%edx
8010737f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107388:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010738e:	83 ca 0f             	or     $0xf,%edx
80107391:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739a:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801073a0:	83 e2 ef             	and    $0xffffffef,%edx
801073a3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ac:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801073b2:	83 e2 df             	and    $0xffffffdf,%edx
801073b5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073be:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801073c4:	83 ca 40             	or     $0x40,%edx
801073c7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d0:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801073d6:	83 ca 80             	or     $0xffffff80,%edx
801073d9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801073df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e2:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801073e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073ec:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801073f3:	ff ff 
801073f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f8:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801073ff:	00 00 
80107401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107404:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010740b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740e:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107414:	83 e2 f0             	and    $0xfffffff0,%edx
80107417:	83 ca 0a             	or     $0xa,%edx
8010741a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107423:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107429:	83 ca 10             	or     $0x10,%edx
8010742c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107435:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010743b:	83 ca 60             	or     $0x60,%edx
8010743e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107444:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107447:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010744d:	83 ca 80             	or     $0xffffff80,%edx
80107450:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107456:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107459:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010745f:	83 ca 0f             	or     $0xf,%edx
80107462:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107471:	83 e2 ef             	and    $0xffffffef,%edx
80107474:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010747a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107483:	83 e2 df             	and    $0xffffffdf,%edx
80107486:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010748c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107495:	83 ca 40             	or     $0x40,%edx
80107498:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010749e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801074a7:	83 ca 80             	or     $0xffffff80,%edx
801074aa:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801074b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b3:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074bd:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801074c4:	ff ff 
801074c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c9:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801074d0:	00 00 
801074d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d5:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801074dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074df:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801074e5:	83 e2 f0             	and    $0xfffffff0,%edx
801074e8:	83 ca 02             	or     $0x2,%edx
801074eb:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801074f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f4:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801074fa:	83 ca 10             	or     $0x10,%edx
801074fd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107506:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010750c:	83 ca 60             	or     $0x60,%edx
8010750f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107518:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010751e:	83 ca 80             	or     $0xffffff80,%edx
80107521:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752a:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107530:	83 ca 0f             	or     $0xf,%edx
80107533:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107542:	83 e2 ef             	and    $0xffffffef,%edx
80107545:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010754b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754e:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107554:	83 e2 df             	and    $0xffffffdf,%edx
80107557:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010755d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107560:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107566:	83 ca 40             	or     $0x40,%edx
80107569:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010756f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107572:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107578:	83 ca 80             	or     $0xffffff80,%edx
8010757b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107584:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010758b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758e:	05 b4 00 00 00       	add    $0xb4,%eax
80107593:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107596:	81 c2 b4 00 00 00    	add    $0xb4,%edx
8010759c:	c1 ea 10             	shr    $0x10,%edx
8010759f:	88 d1                	mov    %dl,%cl
801075a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801075a4:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801075aa:	c1 ea 18             	shr    $0x18,%edx
801075ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801075b0:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801075b7:	00 00 
801075b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801075bc:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801075c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c6:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801075cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075cf:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801075d5:	83 e1 f0             	and    $0xfffffff0,%ecx
801075d8:	83 c9 02             	or     $0x2,%ecx
801075db:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801075e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e4:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801075ea:	83 c9 10             	or     $0x10,%ecx
801075ed:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801075f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f6:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801075fc:	83 e1 9f             	and    $0xffffff9f,%ecx
801075ff:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107605:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107608:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010760e:	83 c9 80             	or     $0xffffff80,%ecx
80107611:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761a:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107620:	83 e1 f0             	and    $0xfffffff0,%ecx
80107623:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762c:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107632:	83 e1 ef             	and    $0xffffffef,%ecx
80107635:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010763b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010763e:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107644:	83 e1 df             	and    $0xffffffdf,%ecx
80107647:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010764d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107650:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107656:	83 c9 40             	or     $0x40,%ecx
80107659:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010765f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107662:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107668:	83 c9 80             	or     $0xffffff80,%ecx
8010766b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107674:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010767a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010767d:	83 c0 70             	add    $0x70,%eax
80107680:	83 ec 08             	sub    $0x8,%esp
80107683:	6a 38                	push   $0x38
80107685:	50                   	push   %eax
80107686:	e8 65 fb ff ff       	call   801071f0 <lgdt>
8010768b:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010768e:	83 ec 0c             	sub    $0xc,%esp
80107691:	6a 18                	push   $0x18
80107693:	e8 94 fb ff ff       	call   8010722c <loadgs>
80107698:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010769b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769e:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801076a4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801076ab:	00 00 00 00 
}
801076af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076b2:	c9                   	leave  
801076b3:	c3                   	ret    

801076b4 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801076ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801076bd:	c1 e8 16             	shr    $0x16,%eax
801076c0:	c1 e0 02             	shl    $0x2,%eax
801076c3:	03 45 08             	add    0x8(%ebp),%eax
801076c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801076c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076cc:	8b 00                	mov    (%eax),%eax
801076ce:	83 e0 01             	and    $0x1,%eax
801076d1:	84 c0                	test   %al,%al
801076d3:	74 18                	je     801076ed <walkpgdir+0x39>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801076d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076d8:	8b 00                	mov    (%eax),%eax
801076da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076df:	50                   	push   %eax
801076e0:	e8 73 fb ff ff       	call   80107258 <p2v>
801076e5:	83 c4 04             	add    $0x4,%esp
801076e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801076eb:	eb 48                	jmp    80107735 <walkpgdir+0x81>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801076ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801076f1:	74 0e                	je     80107701 <walkpgdir+0x4d>
801076f3:	e8 4b b4 ff ff       	call   80102b43 <kalloc>
801076f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801076fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801076ff:	75 07                	jne    80107708 <walkpgdir+0x54>
      return 0;
80107701:	b8 00 00 00 00       	mov    $0x0,%eax
80107706:	eb 3e                	jmp    80107746 <walkpgdir+0x92>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107708:	83 ec 04             	sub    $0x4,%esp
8010770b:	68 00 10 00 00       	push   $0x1000
80107710:	6a 00                	push   $0x0
80107712:	ff 75 f4             	pushl  -0xc(%ebp)
80107715:	e8 c0 d6 ff ff       	call   80104dda <memset>
8010771a:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010771d:	83 ec 0c             	sub    $0xc,%esp
80107720:	ff 75 f4             	pushl  -0xc(%ebp)
80107723:	e8 23 fb ff ff       	call   8010724b <v2p>
80107728:	83 c4 10             	add    $0x10,%esp
8010772b:	89 c2                	mov    %eax,%edx
8010772d:	83 ca 07             	or     $0x7,%edx
80107730:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107733:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107735:	8b 45 0c             	mov    0xc(%ebp),%eax
80107738:	c1 e8 0c             	shr    $0xc,%eax
8010773b:	25 ff 03 00 00       	and    $0x3ff,%eax
80107740:	c1 e0 02             	shl    $0x2,%eax
80107743:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107746:	c9                   	leave  
80107747:	c3                   	ret    

80107748 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107748:	55                   	push   %ebp
80107749:	89 e5                	mov    %esp,%ebp
8010774b:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010774e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107751:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107759:	8b 45 0c             	mov    0xc(%ebp),%eax
8010775c:	03 45 10             	add    0x10(%ebp),%eax
8010775f:	48                   	dec    %eax
80107760:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107765:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107768:	83 ec 04             	sub    $0x4,%esp
8010776b:	6a 01                	push   $0x1
8010776d:	ff 75 f4             	pushl  -0xc(%ebp)
80107770:	ff 75 08             	pushl  0x8(%ebp)
80107773:	e8 3c ff ff ff       	call   801076b4 <walkpgdir>
80107778:	83 c4 10             	add    $0x10,%esp
8010777b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010777e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107782:	75 07                	jne    8010778b <mappages+0x43>
      return -1;
80107784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107789:	eb 48                	jmp    801077d3 <mappages+0x8b>
    if(*pte & PTE_P)
8010778b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010778e:	8b 00                	mov    (%eax),%eax
80107790:	83 e0 01             	and    $0x1,%eax
80107793:	84 c0                	test   %al,%al
80107795:	74 0d                	je     801077a4 <mappages+0x5c>
      panic("remap");
80107797:	83 ec 0c             	sub    $0xc,%esp
8010779a:	68 58 85 10 80       	push   $0x80108558
8010779f:	e8 bb 8d ff ff       	call   8010055f <panic>
    *pte = pa | perm | PTE_P;
801077a4:	8b 45 18             	mov    0x18(%ebp),%eax
801077a7:	0b 45 14             	or     0x14(%ebp),%eax
801077aa:	89 c2                	mov    %eax,%edx
801077ac:	83 ca 01             	or     $0x1,%edx
801077af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801077b2:	89 10                	mov    %edx,(%eax)
    if(a == last)
801077b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801077ba:	75 07                	jne    801077c3 <mappages+0x7b>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801077bc:	b8 00 00 00 00       	mov    $0x0,%eax
801077c1:	eb 10                	jmp    801077d3 <mappages+0x8b>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801077c3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801077ca:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801077d1:	eb 95                	jmp    80107768 <mappages+0x20>
  return 0;
}
801077d3:	c9                   	leave  
801077d4:	c3                   	ret    

801077d5 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801077d5:	55                   	push   %ebp
801077d6:	89 e5                	mov    %esp,%ebp
801077d8:	53                   	push   %ebx
801077d9:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801077dc:	e8 62 b3 ff ff       	call   80102b43 <kalloc>
801077e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801077e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801077e8:	75 0a                	jne    801077f4 <setupkvm+0x1f>
    return 0;
801077ea:	b8 00 00 00 00       	mov    $0x0,%eax
801077ef:	e9 8f 00 00 00       	jmp    80107883 <setupkvm+0xae>
  memset(pgdir, 0, PGSIZE);
801077f4:	83 ec 04             	sub    $0x4,%esp
801077f7:	68 00 10 00 00       	push   $0x1000
801077fc:	6a 00                	push   $0x0
801077fe:	ff 75 f0             	pushl  -0x10(%ebp)
80107801:	e8 d4 d5 ff ff       	call   80104dda <memset>
80107806:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107809:	83 ec 0c             	sub    $0xc,%esp
8010780c:	68 00 00 00 0e       	push   $0xe000000
80107811:	e8 42 fa ff ff       	call   80107258 <p2v>
80107816:	83 c4 10             	add    $0x10,%esp
80107819:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010781e:	76 0d                	jbe    8010782d <setupkvm+0x58>
    panic("PHYSTOP too high");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 5e 85 10 80       	push   $0x8010855e
80107828:	e8 32 8d ff ff       	call   8010055f <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010782d:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107834:	eb 40                	jmp    80107876 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107839:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010783c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010783f:	8b 50 04             	mov    0x4(%eax),%edx
80107842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107845:	8b 58 08             	mov    0x8(%eax),%ebx
80107848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784b:	8b 40 04             	mov    0x4(%eax),%eax
8010784e:	29 c3                	sub    %eax,%ebx
80107850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107853:	8b 00                	mov    (%eax),%eax
80107855:	83 ec 0c             	sub    $0xc,%esp
80107858:	51                   	push   %ecx
80107859:	52                   	push   %edx
8010785a:	53                   	push   %ebx
8010785b:	50                   	push   %eax
8010785c:	ff 75 f0             	pushl  -0x10(%ebp)
8010785f:	e8 e4 fe ff ff       	call   80107748 <mappages>
80107864:	83 c4 20             	add    $0x20,%esp
80107867:	85 c0                	test   %eax,%eax
80107869:	79 07                	jns    80107872 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010786b:	b8 00 00 00 00       	mov    $0x0,%eax
80107870:	eb 11                	jmp    80107883 <setupkvm+0xae>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107872:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107876:	b8 e0 b4 10 80       	mov    $0x8010b4e0,%eax
8010787b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010787e:	72 b6                	jb     80107836 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107880:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107883:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107886:	c9                   	leave  
80107887:	c3                   	ret    

80107888 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107888:	55                   	push   %ebp
80107889:	89 e5                	mov    %esp,%ebp
8010788b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010788e:	e8 42 ff ff ff       	call   801077d5 <setupkvm>
80107893:	a3 f8 26 11 80       	mov    %eax,0x801126f8
  switchkvm();
80107898:	e8 02 00 00 00       	call   8010789f <switchkvm>
}
8010789d:	c9                   	leave  
8010789e:	c3                   	ret    

8010789f <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010789f:	55                   	push   %ebp
801078a0:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801078a2:	a1 f8 26 11 80       	mov    0x801126f8,%eax
801078a7:	50                   	push   %eax
801078a8:	e8 9e f9 ff ff       	call   8010724b <v2p>
801078ad:	83 c4 04             	add    $0x4,%esp
801078b0:	50                   	push   %eax
801078b1:	e8 8a f9 ff ff       	call   80107240 <lcr3>
801078b6:	83 c4 04             	add    $0x4,%esp
}
801078b9:	c9                   	leave  
801078ba:	c3                   	ret    

801078bb <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801078bb:	55                   	push   %ebp
801078bc:	89 e5                	mov    %esp,%ebp
801078be:	53                   	push   %ebx
801078bf:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801078c2:	e8 0e d4 ff ff       	call   80104cd5 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801078c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801078cd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801078d4:	83 c2 08             	add    $0x8,%edx
801078d7:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801078de:	83 c1 08             	add    $0x8,%ecx
801078e1:	c1 e9 10             	shr    $0x10,%ecx
801078e4:	88 cb                	mov    %cl,%bl
801078e6:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801078ed:	83 c1 08             	add    $0x8,%ecx
801078f0:	c1 e9 18             	shr    $0x18,%ecx
801078f3:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801078fa:	67 00 
801078fc:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107903:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107909:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010790f:	83 e2 f0             	and    $0xfffffff0,%edx
80107912:	83 ca 09             	or     $0x9,%edx
80107915:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010791b:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107921:	83 ca 10             	or     $0x10,%edx
80107924:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010792a:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107930:	83 e2 9f             	and    $0xffffff9f,%edx
80107933:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107939:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010793f:	83 ca 80             	or     $0xffffff80,%edx
80107942:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107948:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010794e:	83 e2 f0             	and    $0xfffffff0,%edx
80107951:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107957:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010795d:	83 e2 ef             	and    $0xffffffef,%edx
80107960:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107966:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010796c:	83 e2 df             	and    $0xffffffdf,%edx
8010796f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107975:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010797b:	83 ca 40             	or     $0x40,%edx
8010797e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107984:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010798a:	83 e2 7f             	and    $0x7f,%edx
8010798d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107993:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107999:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010799f:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801079a5:	83 e2 ef             	and    $0xffffffef,%edx
801079a8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801079ae:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079b4:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801079ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801079c0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801079c7:	8b 52 08             	mov    0x8(%edx),%edx
801079ca:	81 c2 00 10 00 00    	add    $0x1000,%edx
801079d0:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801079d3:	83 ec 0c             	sub    $0xc,%esp
801079d6:	6a 30                	push   $0x30
801079d8:	e8 3a f8 ff ff       	call   80107217 <ltr>
801079dd:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801079e0:	8b 45 08             	mov    0x8(%ebp),%eax
801079e3:	8b 40 04             	mov    0x4(%eax),%eax
801079e6:	85 c0                	test   %eax,%eax
801079e8:	75 0d                	jne    801079f7 <switchuvm+0x13c>
    panic("switchuvm: no pgdir");
801079ea:	83 ec 0c             	sub    $0xc,%esp
801079ed:	68 6f 85 10 80       	push   $0x8010856f
801079f2:	e8 68 8b ff ff       	call   8010055f <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801079f7:	8b 45 08             	mov    0x8(%ebp),%eax
801079fa:	8b 40 04             	mov    0x4(%eax),%eax
801079fd:	83 ec 0c             	sub    $0xc,%esp
80107a00:	50                   	push   %eax
80107a01:	e8 45 f8 ff ff       	call   8010724b <v2p>
80107a06:	83 c4 10             	add    $0x10,%esp
80107a09:	83 ec 0c             	sub    $0xc,%esp
80107a0c:	50                   	push   %eax
80107a0d:	e8 2e f8 ff ff       	call   80107240 <lcr3>
80107a12:	83 c4 10             	add    $0x10,%esp
  popcli();
80107a15:	e8 01 d3 ff ff       	call   80104d1b <popcli>
}
80107a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107a1d:	c9                   	leave  
80107a1e:	c3                   	ret    

80107a1f <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107a1f:	55                   	push   %ebp
80107a20:	89 e5                	mov    %esp,%ebp
80107a22:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107a25:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107a2c:	76 0d                	jbe    80107a3b <inituvm+0x1c>
    panic("inituvm: more than a page");
80107a2e:	83 ec 0c             	sub    $0xc,%esp
80107a31:	68 83 85 10 80       	push   $0x80108583
80107a36:	e8 24 8b ff ff       	call   8010055f <panic>
  mem = kalloc();
80107a3b:	e8 03 b1 ff ff       	call   80102b43 <kalloc>
80107a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107a43:	83 ec 04             	sub    $0x4,%esp
80107a46:	68 00 10 00 00       	push   $0x1000
80107a4b:	6a 00                	push   $0x0
80107a4d:	ff 75 f4             	pushl  -0xc(%ebp)
80107a50:	e8 85 d3 ff ff       	call   80104dda <memset>
80107a55:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107a58:	83 ec 0c             	sub    $0xc,%esp
80107a5b:	ff 75 f4             	pushl  -0xc(%ebp)
80107a5e:	e8 e8 f7 ff ff       	call   8010724b <v2p>
80107a63:	83 c4 10             	add    $0x10,%esp
80107a66:	83 ec 0c             	sub    $0xc,%esp
80107a69:	6a 06                	push   $0x6
80107a6b:	50                   	push   %eax
80107a6c:	68 00 10 00 00       	push   $0x1000
80107a71:	6a 00                	push   $0x0
80107a73:	ff 75 08             	pushl  0x8(%ebp)
80107a76:	e8 cd fc ff ff       	call   80107748 <mappages>
80107a7b:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107a7e:	83 ec 04             	sub    $0x4,%esp
80107a81:	ff 75 10             	pushl  0x10(%ebp)
80107a84:	ff 75 0c             	pushl  0xc(%ebp)
80107a87:	ff 75 f4             	pushl  -0xc(%ebp)
80107a8a:	e8 07 d4 ff ff       	call   80104e96 <memmove>
80107a8f:	83 c4 10             	add    $0x10,%esp
}
80107a92:	c9                   	leave  
80107a93:	c3                   	ret    

80107a94 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a94:	55                   	push   %ebp
80107a95:	89 e5                	mov    %esp,%ebp
80107a97:	53                   	push   %ebx
80107a98:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a9e:	25 ff 0f 00 00       	and    $0xfff,%eax
80107aa3:	85 c0                	test   %eax,%eax
80107aa5:	74 0d                	je     80107ab4 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107aa7:	83 ec 0c             	sub    $0xc,%esp
80107aaa:	68 a0 85 10 80       	push   $0x801085a0
80107aaf:	e8 ab 8a ff ff       	call   8010055f <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ab4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107abb:	e9 a2 00 00 00       	jmp    80107b62 <loaduvm+0xce>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ac6:	8d 04 02             	lea    (%edx,%eax,1),%eax
80107ac9:	83 ec 04             	sub    $0x4,%esp
80107acc:	6a 00                	push   $0x0
80107ace:	50                   	push   %eax
80107acf:	ff 75 08             	pushl  0x8(%ebp)
80107ad2:	e8 dd fb ff ff       	call   801076b4 <walkpgdir>
80107ad7:	83 c4 10             	add    $0x10,%esp
80107ada:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107add:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ae1:	75 0d                	jne    80107af0 <loaduvm+0x5c>
      panic("loaduvm: address should exist");
80107ae3:	83 ec 0c             	sub    $0xc,%esp
80107ae6:	68 c3 85 10 80       	push   $0x801085c3
80107aeb:	e8 6f 8a ff ff       	call   8010055f <panic>
    pa = PTE_ADDR(*pte);
80107af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107af3:	8b 00                	mov    (%eax),%eax
80107af5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107afa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b00:	8b 55 18             	mov    0x18(%ebp),%edx
80107b03:	89 d1                	mov    %edx,%ecx
80107b05:	29 c1                	sub    %eax,%ecx
80107b07:	89 c8                	mov    %ecx,%eax
80107b09:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107b0e:	77 11                	ja     80107b21 <loaduvm+0x8d>
      n = sz - i;
80107b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b13:	8b 55 18             	mov    0x18(%ebp),%edx
80107b16:	89 d1                	mov    %edx,%ecx
80107b18:	29 c1                	sub    %eax,%ecx
80107b1a:	89 c8                	mov    %ecx,%eax
80107b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107b1f:	eb 07                	jmp    80107b28 <loaduvm+0x94>
    else
      n = PGSIZE;
80107b21:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2b:	8b 55 14             	mov    0x14(%ebp),%edx
80107b2e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107b31:	83 ec 0c             	sub    $0xc,%esp
80107b34:	ff 75 e8             	pushl  -0x18(%ebp)
80107b37:	e8 1c f7 ff ff       	call   80107258 <p2v>
80107b3c:	83 c4 10             	add    $0x10,%esp
80107b3f:	ff 75 f0             	pushl  -0x10(%ebp)
80107b42:	53                   	push   %ebx
80107b43:	50                   	push   %eax
80107b44:	ff 75 10             	pushl  0x10(%ebp)
80107b47:	e8 a6 a2 ff ff       	call   80101df2 <readi>
80107b4c:	83 c4 10             	add    $0x10,%esp
80107b4f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107b52:	74 07                	je     80107b5b <loaduvm+0xc7>
      return -1;
80107b54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b59:	eb 18                	jmp    80107b73 <loaduvm+0xdf>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107b5b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b65:	3b 45 18             	cmp    0x18(%ebp),%eax
80107b68:	0f 82 52 ff ff ff    	jb     80107ac0 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107b6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b76:	c9                   	leave  
80107b77:	c3                   	ret    

80107b78 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b78:	55                   	push   %ebp
80107b79:	89 e5                	mov    %esp,%ebp
80107b7b:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107b7e:	8b 45 10             	mov    0x10(%ebp),%eax
80107b81:	85 c0                	test   %eax,%eax
80107b83:	79 0a                	jns    80107b8f <allocuvm+0x17>
    return 0;
80107b85:	b8 00 00 00 00       	mov    $0x0,%eax
80107b8a:	e9 ae 00 00 00       	jmp    80107c3d <allocuvm+0xc5>
  if(newsz < oldsz)
80107b8f:	8b 45 10             	mov    0x10(%ebp),%eax
80107b92:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107b95:	73 08                	jae    80107b9f <allocuvm+0x27>
    return oldsz;
80107b97:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b9a:	e9 9e 00 00 00       	jmp    80107c3d <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
80107b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ba7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107baf:	eb 7d                	jmp    80107c2e <allocuvm+0xb6>
    mem = kalloc();
80107bb1:	e8 8d af ff ff       	call   80102b43 <kalloc>
80107bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107bb9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bbd:	75 2b                	jne    80107bea <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80107bbf:	83 ec 0c             	sub    $0xc,%esp
80107bc2:	68 e1 85 10 80       	push   $0x801085e1
80107bc7:	e8 f4 87 ff ff       	call   801003c0 <cprintf>
80107bcc:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80107bcf:	83 ec 04             	sub    $0x4,%esp
80107bd2:	ff 75 0c             	pushl  0xc(%ebp)
80107bd5:	ff 75 10             	pushl  0x10(%ebp)
80107bd8:	ff 75 08             	pushl  0x8(%ebp)
80107bdb:	e8 5f 00 00 00       	call   80107c3f <deallocuvm>
80107be0:	83 c4 10             	add    $0x10,%esp
      return 0;
80107be3:	b8 00 00 00 00       	mov    $0x0,%eax
80107be8:	eb 53                	jmp    80107c3d <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
80107bea:	83 ec 04             	sub    $0x4,%esp
80107bed:	68 00 10 00 00       	push   $0x1000
80107bf2:	6a 00                	push   $0x0
80107bf4:	ff 75 f0             	pushl  -0x10(%ebp)
80107bf7:	e8 de d1 ff ff       	call   80104dda <memset>
80107bfc:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107bff:	83 ec 0c             	sub    $0xc,%esp
80107c02:	ff 75 f0             	pushl  -0x10(%ebp)
80107c05:	e8 41 f6 ff ff       	call   8010724b <v2p>
80107c0a:	83 c4 10             	add    $0x10,%esp
80107c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c10:	83 ec 0c             	sub    $0xc,%esp
80107c13:	6a 06                	push   $0x6
80107c15:	50                   	push   %eax
80107c16:	68 00 10 00 00       	push   $0x1000
80107c1b:	52                   	push   %edx
80107c1c:	ff 75 08             	pushl  0x8(%ebp)
80107c1f:	e8 24 fb ff ff       	call   80107748 <mappages>
80107c24:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107c27:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c31:	3b 45 10             	cmp    0x10(%ebp),%eax
80107c34:	0f 82 77 ff ff ff    	jb     80107bb1 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80107c3a:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107c3d:	c9                   	leave  
80107c3e:	c3                   	ret    

80107c3f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c3f:	55                   	push   %ebp
80107c40:	89 e5                	mov    %esp,%ebp
80107c42:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107c45:	8b 45 10             	mov    0x10(%ebp),%eax
80107c48:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107c4b:	72 08                	jb     80107c55 <deallocuvm+0x16>
    return oldsz;
80107c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c50:	e9 a5 00 00 00       	jmp    80107cfa <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80107c55:	8b 45 10             	mov    0x10(%ebp),%eax
80107c58:	05 ff 0f 00 00       	add    $0xfff,%eax
80107c5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107c65:	e9 81 00 00 00       	jmp    80107ceb <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6d:	83 ec 04             	sub    $0x4,%esp
80107c70:	6a 00                	push   $0x0
80107c72:	50                   	push   %eax
80107c73:	ff 75 08             	pushl  0x8(%ebp)
80107c76:	e8 39 fa ff ff       	call   801076b4 <walkpgdir>
80107c7b:	83 c4 10             	add    $0x10,%esp
80107c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c85:	75 09                	jne    80107c90 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80107c87:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107c8e:	eb 54                	jmp    80107ce4 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80107c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c93:	8b 00                	mov    (%eax),%eax
80107c95:	83 e0 01             	and    $0x1,%eax
80107c98:	84 c0                	test   %al,%al
80107c9a:	74 48                	je     80107ce4 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80107c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c9f:	8b 00                	mov    (%eax),%eax
80107ca1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107ca9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cad:	75 0d                	jne    80107cbc <deallocuvm+0x7d>
        panic("kfree");
80107caf:	83 ec 0c             	sub    $0xc,%esp
80107cb2:	68 f9 85 10 80       	push   $0x801085f9
80107cb7:	e8 a3 88 ff ff       	call   8010055f <panic>
      char *v = p2v(pa);
80107cbc:	83 ec 0c             	sub    $0xc,%esp
80107cbf:	ff 75 ec             	pushl  -0x14(%ebp)
80107cc2:	e8 91 f5 ff ff       	call   80107258 <p2v>
80107cc7:	83 c4 10             	add    $0x10,%esp
80107cca:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107ccd:	83 ec 0c             	sub    $0xc,%esp
80107cd0:	ff 75 e8             	pushl  -0x18(%ebp)
80107cd3:	e8 cf ad ff ff       	call   80102aa7 <kfree>
80107cd8:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80107cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107ce4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cee:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cf1:	0f 82 73 ff ff ff    	jb     80107c6a <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80107cf7:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cfa:	c9                   	leave  
80107cfb:	c3                   	ret    

80107cfc <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cfc:	55                   	push   %ebp
80107cfd:	89 e5                	mov    %esp,%ebp
80107cff:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80107d02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d06:	75 0d                	jne    80107d15 <freevm+0x19>
    panic("freevm: no pgdir");
80107d08:	83 ec 0c             	sub    $0xc,%esp
80107d0b:	68 ff 85 10 80       	push   $0x801085ff
80107d10:	e8 4a 88 ff ff       	call   8010055f <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107d15:	83 ec 04             	sub    $0x4,%esp
80107d18:	6a 00                	push   $0x0
80107d1a:	68 00 00 00 80       	push   $0x80000000
80107d1f:	ff 75 08             	pushl  0x8(%ebp)
80107d22:	e8 18 ff ff ff       	call   80107c3f <deallocuvm>
80107d27:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107d31:	eb 42                	jmp    80107d75 <freevm+0x79>
    if(pgdir[i] & PTE_P){
80107d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d36:	c1 e0 02             	shl    $0x2,%eax
80107d39:	03 45 08             	add    0x8(%ebp),%eax
80107d3c:	8b 00                	mov    (%eax),%eax
80107d3e:	83 e0 01             	and    $0x1,%eax
80107d41:	84 c0                	test   %al,%al
80107d43:	74 2d                	je     80107d72 <freevm+0x76>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d48:	c1 e0 02             	shl    $0x2,%eax
80107d4b:	03 45 08             	add    0x8(%ebp),%eax
80107d4e:	8b 00                	mov    (%eax),%eax
80107d50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d55:	83 ec 0c             	sub    $0xc,%esp
80107d58:	50                   	push   %eax
80107d59:	e8 fa f4 ff ff       	call   80107258 <p2v>
80107d5e:	83 c4 10             	add    $0x10,%esp
80107d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107d64:	83 ec 0c             	sub    $0xc,%esp
80107d67:	ff 75 f0             	pushl  -0x10(%ebp)
80107d6a:	e8 38 ad ff ff       	call   80102aa7 <kfree>
80107d6f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107d72:	ff 45 f4             	incl   -0xc(%ebp)
80107d75:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107d7c:	76 b5                	jbe    80107d33 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80107d81:	83 ec 0c             	sub    $0xc,%esp
80107d84:	50                   	push   %eax
80107d85:	e8 1d ad ff ff       	call   80102aa7 <kfree>
80107d8a:	83 c4 10             	add    $0x10,%esp
}
80107d8d:	c9                   	leave  
80107d8e:	c3                   	ret    

80107d8f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d8f:	55                   	push   %ebp
80107d90:	89 e5                	mov    %esp,%ebp
80107d92:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107d95:	83 ec 04             	sub    $0x4,%esp
80107d98:	6a 00                	push   $0x0
80107d9a:	ff 75 0c             	pushl  0xc(%ebp)
80107d9d:	ff 75 08             	pushl  0x8(%ebp)
80107da0:	e8 0f f9 ff ff       	call   801076b4 <walkpgdir>
80107da5:	83 c4 10             	add    $0x10,%esp
80107da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107dab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107daf:	75 0d                	jne    80107dbe <clearpteu+0x2f>
    panic("clearpteu");
80107db1:	83 ec 0c             	sub    $0xc,%esp
80107db4:	68 10 86 10 80       	push   $0x80108610
80107db9:	e8 a1 87 ff ff       	call   8010055f <panic>
  *pte &= ~PTE_U;
80107dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc1:	8b 00                	mov    (%eax),%eax
80107dc3:	89 c2                	mov    %eax,%edx
80107dc5:	83 e2 fb             	and    $0xfffffffb,%edx
80107dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcb:	89 10                	mov    %edx,(%eax)
}
80107dcd:	c9                   	leave  
80107dce:	c3                   	ret    

80107dcf <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107dcf:	55                   	push   %ebp
80107dd0:	89 e5                	mov    %esp,%ebp
80107dd2:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
80107dd5:	e8 fb f9 ff ff       	call   801077d5 <setupkvm>
80107dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ddd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107de1:	75 0a                	jne    80107ded <copyuvm+0x1e>
    return 0;
80107de3:	b8 00 00 00 00       	mov    $0x0,%eax
80107de8:	e9 e7 00 00 00       	jmp    80107ed4 <copyuvm+0x105>
  for(i = 0; i < sz; i += PGSIZE){
80107ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107df4:	e9 b3 00 00 00       	jmp    80107eac <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dfc:	83 ec 04             	sub    $0x4,%esp
80107dff:	6a 00                	push   $0x0
80107e01:	50                   	push   %eax
80107e02:	ff 75 08             	pushl  0x8(%ebp)
80107e05:	e8 aa f8 ff ff       	call   801076b4 <walkpgdir>
80107e0a:	83 c4 10             	add    $0x10,%esp
80107e0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107e10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e14:	75 0d                	jne    80107e23 <copyuvm+0x54>
      panic("copyuvm: pte should exist");
80107e16:	83 ec 0c             	sub    $0xc,%esp
80107e19:	68 1a 86 10 80       	push   $0x8010861a
80107e1e:	e8 3c 87 ff ff       	call   8010055f <panic>
    if(!(*pte & PTE_P))
80107e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e26:	8b 00                	mov    (%eax),%eax
80107e28:	83 e0 01             	and    $0x1,%eax
80107e2b:	85 c0                	test   %eax,%eax
80107e2d:	75 0d                	jne    80107e3c <copyuvm+0x6d>
      panic("copyuvm: page not present");
80107e2f:	83 ec 0c             	sub    $0xc,%esp
80107e32:	68 34 86 10 80       	push   $0x80108634
80107e37:	e8 23 87 ff ff       	call   8010055f <panic>
    pa = PTE_ADDR(*pte);
80107e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e3f:	8b 00                	mov    (%eax),%eax
80107e41:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e46:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
80107e49:	e8 f5 ac ff ff       	call   80102b43 <kalloc>
80107e4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e51:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80107e55:	74 66                	je     80107ebd <copyuvm+0xee>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80107e57:	83 ec 0c             	sub    $0xc,%esp
80107e5a:	ff 75 e8             	pushl  -0x18(%ebp)
80107e5d:	e8 f6 f3 ff ff       	call   80107258 <p2v>
80107e62:	83 c4 10             	add    $0x10,%esp
80107e65:	83 ec 04             	sub    $0x4,%esp
80107e68:	68 00 10 00 00       	push   $0x1000
80107e6d:	50                   	push   %eax
80107e6e:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e71:	e8 20 d0 ff ff       	call   80104e96 <memmove>
80107e76:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80107e79:	83 ec 0c             	sub    $0xc,%esp
80107e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e7f:	e8 c7 f3 ff ff       	call   8010724b <v2p>
80107e84:	83 c4 10             	add    $0x10,%esp
80107e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e8a:	83 ec 0c             	sub    $0xc,%esp
80107e8d:	6a 06                	push   $0x6
80107e8f:	50                   	push   %eax
80107e90:	68 00 10 00 00       	push   $0x1000
80107e95:	52                   	push   %edx
80107e96:	ff 75 f0             	pushl  -0x10(%ebp)
80107e99:	e8 aa f8 ff ff       	call   80107748 <mappages>
80107e9e:	83 c4 20             	add    $0x20,%esp
80107ea1:	85 c0                	test   %eax,%eax
80107ea3:	78 1b                	js     80107ec0 <copyuvm+0xf1>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107ea5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eaf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107eb2:	0f 82 41 ff ff ff    	jb     80107df9 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
80107eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ebb:	eb 17                	jmp    80107ed4 <copyuvm+0x105>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80107ebd:	90                   	nop
80107ebe:	eb 01                	jmp    80107ec1 <copyuvm+0xf2>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80107ec0:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80107ec1:	83 ec 0c             	sub    $0xc,%esp
80107ec4:	ff 75 f0             	pushl  -0x10(%ebp)
80107ec7:	e8 30 fe ff ff       	call   80107cfc <freevm>
80107ecc:	83 c4 10             	add    $0x10,%esp
  return 0;
80107ecf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ed4:	c9                   	leave  
80107ed5:	c3                   	ret    

80107ed6 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ed6:	55                   	push   %ebp
80107ed7:	89 e5                	mov    %esp,%ebp
80107ed9:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107edc:	83 ec 04             	sub    $0x4,%esp
80107edf:	6a 00                	push   $0x0
80107ee1:	ff 75 0c             	pushl  0xc(%ebp)
80107ee4:	ff 75 08             	pushl  0x8(%ebp)
80107ee7:	e8 c8 f7 ff ff       	call   801076b4 <walkpgdir>
80107eec:	83 c4 10             	add    $0x10,%esp
80107eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	8b 00                	mov    (%eax),%eax
80107ef7:	83 e0 01             	and    $0x1,%eax
80107efa:	85 c0                	test   %eax,%eax
80107efc:	75 07                	jne    80107f05 <uva2ka+0x2f>
    return 0;
80107efe:	b8 00 00 00 00       	mov    $0x0,%eax
80107f03:	eb 29                	jmp    80107f2e <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80107f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f08:	8b 00                	mov    (%eax),%eax
80107f0a:	83 e0 04             	and    $0x4,%eax
80107f0d:	85 c0                	test   %eax,%eax
80107f0f:	75 07                	jne    80107f18 <uva2ka+0x42>
    return 0;
80107f11:	b8 00 00 00 00       	mov    $0x0,%eax
80107f16:	eb 16                	jmp    80107f2e <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80107f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1b:	8b 00                	mov    (%eax),%eax
80107f1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f22:	83 ec 0c             	sub    $0xc,%esp
80107f25:	50                   	push   %eax
80107f26:	e8 2d f3 ff ff       	call   80107258 <p2v>
80107f2b:	83 c4 10             	add    $0x10,%esp
}
80107f2e:	c9                   	leave  
80107f2f:	c3                   	ret    

80107f30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80107f36:	8b 45 10             	mov    0x10(%ebp),%eax
80107f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80107f3c:	e9 87 00 00 00       	jmp    80107fc8 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80107f41:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f49:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f4f:	83 ec 08             	sub    $0x8,%esp
80107f52:	50                   	push   %eax
80107f53:	ff 75 08             	pushl  0x8(%ebp)
80107f56:	e8 7b ff ff ff       	call   80107ed6 <uva2ka>
80107f5b:	83 c4 10             	add    $0x10,%esp
80107f5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80107f61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80107f65:	75 07                	jne    80107f6e <copyout+0x3e>
      return -1;
80107f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f6c:	eb 69                	jmp    80107fd7 <copyout+0xa7>
    n = PGSIZE - (va - va0);
80107f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f71:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107f74:	89 d1                	mov    %edx,%ecx
80107f76:	29 c1                	sub    %eax,%ecx
80107f78:	89 c8                	mov    %ecx,%eax
80107f7a:	05 00 10 00 00       	add    $0x1000,%eax
80107f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80107f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f85:	3b 45 14             	cmp    0x14(%ebp),%eax
80107f88:	76 06                	jbe    80107f90 <copyout+0x60>
      n = len;
80107f8a:	8b 45 14             	mov    0x14(%ebp),%eax
80107f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80107f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f93:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f96:	89 d1                	mov    %edx,%ecx
80107f98:	29 c1                	sub    %eax,%ecx
80107f9a:	89 c8                	mov    %ecx,%eax
80107f9c:	03 45 e8             	add    -0x18(%ebp),%eax
80107f9f:	83 ec 04             	sub    $0x4,%esp
80107fa2:	ff 75 f0             	pushl  -0x10(%ebp)
80107fa5:	ff 75 f4             	pushl  -0xc(%ebp)
80107fa8:	50                   	push   %eax
80107fa9:	e8 e8 ce ff ff       	call   80104e96 <memmove>
80107fae:	83 c4 10             	add    $0x10,%esp
    len -= n;
80107fb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fb4:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80107fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fba:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80107fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc0:	05 00 10 00 00       	add    $0x1000,%eax
80107fc5:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107fc8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80107fcc:	0f 85 6f ff ff ff    	jne    80107f41 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107fd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fd7:	c9                   	leave  
80107fd8:	c3                   	ret    
