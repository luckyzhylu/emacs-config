/*-
 * Copyright (c) 1990, 1993, 1994
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	@(#)db.h	8.7 (Berkeley) 6/16/94
 */

#ifndef _DB_H_
#define	_DB_H_

/** @file */

#include <sys/types.h>

#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "compat.h"

/** @name Return values. */
/** @{ */
#define	RET_ERROR	-1
#define	RET_SUCCESS	 0
#define	RET_SPECIAL	 1
/** @} */

/** @name */
/** @{ */
				/** >= \# of pages in a file */
#define	MAX_PAGE_NUMBER	0xffffffff
				/** pgno_t */
#define pgno_t		u_int32_t
				/** >= \# of bytes in a page */
#define	MAX_PAGE_OFFSET	65535
				/** indx_t */
#define indx_t		u_int16_t
				/** >= \# of records in a tree */
#define	MAX_REC_NUMBER	0xffffffff
				/** recno_t */
#define recno_t		u_int32_t
/** @} */

/** Key/data structure -- a Data-Base Thang. */
typedef struct {
	void	*data;			/**< data */
	size_t	 size;			/**< data length */
} DBT;

/** @name Routine flags. */
/** @{ */
		/** del, put, seq */
#define	R_CURSOR	1
		/** UNUSED */
#define	__R_UNUSED	2
		/** seq */
#define	R_FIRST		3
		/** put (RECNO) */
#define	R_IAFTER	4
		/** put (RECNO) */
#define	R_IBEFORE	5
		/** seq (#BTREE, RECNO) */
#define	R_LAST		6
		/** seq */
#define	R_NEXT		7
		/** put */
#define	R_NOOVERWRITE	8
		/** seq (#BTREE, RECNO) */
#define	R_PREV		9
		/** put (RECNO) */
#define	R_SETCURSOR	10
		/** sync (RECNO) */
#define	R_RECNOSYNC	11
/** @} */

typedef enum { DB_BTREE, DB_HASH, DB_RECNO } DBTYPE;

/**
 * !!!
 * The following flags are included in the @XREF{dbopen,3} call as part of the
 * @XREF{open,2} flags.  In order to avoid conflicts with the open flags, start
 * at the top of the 16 or 32-bit number space and work our way down.  If
 * the open flags were significantly expanded in the future, it could be
 * a problem.  Wish I'd left another flags word in the @NAME{dbopen} call.
 *
 * !!!
 * @EMPH{None of this stuff is implemented yet}.  The only reason that it's here
 * is so that the access methods can skip copying the key/data pair when
 * the #DB_LOCK flag isn't set.
 */
#if UINT_MAX > 65535
				/** Do locking. */
#define	DB_LOCK		0x20000000
				/** Use shared memory. */
#define	DB_SHMEM	0x40000000
				/** Do transactions. */
#define	DB_TXN		0x80000000
#else
				/** Do locking. */
#define	DB_LOCK		    0x2000
				/** Use shared memory. */
#define	DB_SHMEM	    0x4000
				/** Do transactions. */
#define	DB_TXN		    0x8000
#endif

/** Access method description structure. */
typedef struct __db {
	DBTYPE type;			/**< Underlying db type. */
	/** The 2nd argument was added in order to
	   avoid useless writing just before unlink. */
	int (*close)	(struct __db *, int);
	int (*del)	(const struct __db *, const DBT *, u_int);
	int (*get)	(const struct __db *, const DBT *, DBT *, u_int);
	int (*put)	(const struct __db *, DBT *, const DBT *, u_int);
	int (*seq)	(const struct __db *, DBT *, DBT *, u_int);
	int (*sync)	(const struct __db *, u_int);
	void *internal;			/**< Access method private. */
	int (*fd)	(const struct __db *);
} DB;

/** @name */
/** @{ */
#define	BTREEMAGIC	0x053162
#define	BTREEVERSION	3
		/** duplicate keys */
#define	R_DUP		0x01
/** @} */

/** Structure used to pass parameters to the btree routines. */
typedef struct {
	u_long	flags;
	u_int	cachesize;	/**< bytes to cache */
	int	maxkeypage;	/**< maximum keys per page */
	int	minkeypage;	/**< minimum keys per page */
	u_int	psize;		/**< page size */
	int	(*compare)	/**< comparison function */
	   (const DBT *, const DBT *);
	size_t	(*prefix)	/**< prefix function */
	   (const DBT *, const DBT *);
	int	lorder;		/**< byte order */
} BTREEINFO;

#define	HASHMAGIC	0x061561
#define	HASHVERSION	2

/** Structure used to pass parameters to the hashing routines. */
typedef struct {
	u_int	bsize;		/**< bucket size */
	u_int	ffactor;	/**< fill factor */
	u_int	nelem;		/**< number of elements */
	u_int	cachesize;	/**< bytes to cache */
	u_int32_t		/** hash function */
		(*hash)(const void *, size_t);
	int	lorder;		/**< byte order */
} HASHINFO;

		/** fixed-length records */
#define	R_FIXEDLEN	0x01
		/** key not required */
#define	R_NOKEY		0x02
		/** snapshot the input */
#define	R_SNAPSHOT	0x04

/** Structure used to pass parameters to the record routines. */
typedef struct {
	u_long	flags;
	u_int	cachesize;	/**< bytes to cache */
	u_int	psize;		/**< page size */
	int	lorder;		/**< byte order */
	size_t	reclen;		/**< record length (fixed-length records) */
	u_char	bval;		/**< delimiting byte (variable-length records */
	char	*bfname;	/**< btree file name */ 
} RECNOINFO;

/**
 * @name Little endian <==> big endian 32-bit swap macros.
 *	#M_32_SWAP	swap a memory location <br>
 *	#P_32_SWAP	swap a referenced memory location <br>
 *	#P_32_COPY	swap from one location to another
 */
/** @{ */
#define	M_32_SWAP(a) {							\
	u_int32_t _tmp = a;						\
	((char *)&a)[0] = ((char *)&_tmp)[3];				\
	((char *)&a)[1] = ((char *)&_tmp)[2];				\
	((char *)&a)[2] = ((char *)&_tmp)[1];				\
	((char *)&a)[3] = ((char *)&_tmp)[0];				\
}
#define	P_32_SWAP(a) {							\
	u_int32_t _tmp = *(u_int32_t *)a;				\
	((char *)a)[0] = ((char *)&_tmp)[3];				\
	((char *)a)[1] = ((char *)&_tmp)[2];				\
	((char *)a)[2] = ((char *)&_tmp)[1];				\
	((char *)a)[3] = ((char *)&_tmp)[0];				\
}
#define	P_32_COPY(a, b) {						\
	((char *)&(b))[0] = ((char *)&(a))[3];				\
	((char *)&(b))[1] = ((char *)&(a))[2];				\
	((char *)&(b))[2] = ((char *)&(a))[1];				\
	((char *)&(b))[3] = ((char *)&(a))[0];				\
}
/** @} */

/**
 * @name Little endian <==> big endian 16-bit swap macros.
 *	#M_16_SWAP	swap a memory location <br>
 *	#P_16_SWAP	swap a referenced memory location <br>
 *	#P_16_COPY	swap from one location to another
 */
/** @{ */
#define	M_16_SWAP(a) {							\
	u_int16_t _tmp = a;						\
	((char *)&a)[0] = ((char *)&_tmp)[1];				\
	((char *)&a)[1] = ((char *)&_tmp)[0];				\
}
#define	P_16_SWAP(a) {							\
	u_int16_t _tmp = *(u_int16_t *)a;				\
	((char *)a)[0] = ((char *)&_tmp)[1];				\
	((char *)a)[1] = ((char *)&_tmp)[0];				\
}
#define	P_16_COPY(a, b) {						\
	((char *)&(b))[0] = ((char *)&(a))[1];				\
	((char *)&(b))[1] = ((char *)&(a))[0];				\
}
/** @} */

DB	*dbopen(const char *, int, int, DBTYPE, const void *);

DB	*__bt_open(const char *, int, int, const BTREEINFO *, int);
DB	*__hash_open(const char *, int, int, const HASHINFO *, int);
DB	*__rec_open(const char *, int, int, const RECNOINFO *, int);
void	 __dbpanic(DB *dbp);
#endif /* !_DB_H_ */
