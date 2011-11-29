/*
 * Util.h
 *
 *  Created on: Mar 29, 2009
 *      Author: ivan_deras
 */

#ifndef UTIL_H_
#define UTIL_H_

#include <list>

using namespace std;

/*
 * Libera una lista.  El tipo T debe ser un apuntador.
 */
template <typename T>
void inline FreeList(list<T> *l)
{
	typename list<T>::iterator it = l->begin();

	while (it != l->end()) {
		T element = *it;

		delete element;

		it++;
	}
	l->clear();
}

#endif /* UTIL_H_ */
