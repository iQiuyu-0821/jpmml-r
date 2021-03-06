/*
 * Copyright (c) 2015 Villu Ruusmann
 *
 * This file is part of JPMML-R
 *
 * JPMML-R is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * JPMML-R is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with JPMML-R.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.jpmml.rexp;

import java.io.InputStream;

import org.dmg.pmml.PMML;
import org.jpmml.evaluator.ArchiveBatch;
import org.jpmml.evaluator.IntegrationTest;

abstract
public class ConverterTest extends IntegrationTest {

	@Override
	protected ArchiveBatch createBatch(String name, String dataset){
		return createBatch(name, dataset, null);
	}

	protected ArchiveBatch createBatch(String name, String dataset, final Class<? extends Converter<? extends RExp>> clazz){
		ArchiveBatch result = new ArchiveBatch(name, dataset){

			@Override
			public InputStream open(String path){
				Class<? extends ConverterTest> clazz = ConverterTest.this.getClass();

				return clazz.getResourceAsStream(path);
			}

			@Override
			public PMML getPMML() throws Exception {

				try(InputStream is = open("/rds/" + getName() + getDataset() + ".rds")){
					RExpParser parser = new RExpParser(is);

					RExp rexp = parser.parse();

					return convert(rexp, clazz);
				}
			}
		};

		return result;
	}

	static
	private PMML convert(RExp rexp, Class<? extends Converter<? extends RExp>> clazz) throws Exception {
		ConverterFactory converterFactory = ConverterFactory.newInstance();

		Converter<RExp> converter;

		if(clazz != null){
			converter = converterFactory.newConverter(clazz, rexp);
		} else

		{
			converter = converterFactory.newConverter(rexp);
		}

		return converter.encodePMML();
	}
}