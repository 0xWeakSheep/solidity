/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0
/**
 * Component that collects variables that are never assigned to and their
 * initial values.
 */

#include <libyul/optimiser/SSAValueTracker.h>

#include <liblangutil/Exceptions.h>

#include <libyul/AST.h>

using namespace solidity;
using namespace solidity::yul;

void SSAValueTracker::operator()(Assignment const& _assignment)
{
	for (auto const& var: _assignment.variableNames)
		m_values.erase(var.name);
}

void SSAValueTracker::operator()(FunctionDefinition const& _funDef)
{
	solAssert(!m_values.contains(_funDef.name), "SSAValueTracker requires Disambiguator to run first");

	for (auto const& param: _funDef.parameters)
		m_values[param.name] = nullptr;

	for (auto const& var: _funDef.returnVariables)
		setValue(var.name, nullptr);
	ASTWalker::operator()(_funDef);
}

void SSAValueTracker::operator()(VariableDeclaration const& _varDecl)
{
	if (!_varDecl.value)
		for (auto const& var: _varDecl.variables)
			setValue(var.name, nullptr);
	else if (_varDecl.variables.size() == 1)
		setValue(_varDecl.variables.front().name, _varDecl.value.get());
}

bool SSAValueTracker::isSSAWithDependencies(Expression const* _expression) const
{
	if (_expression == nullptr)
		return true;

	if (auto const* functionCall = std::get_if<FunctionCall>(_expression))
	{
		for (auto const& argument: functionCall->arguments)
			if (!isSSAWithDependencies(&argument))
				return false;

		return true;
	}
	else if (auto const* identifier = std::get_if<Identifier>(_expression))
	{
		auto const it = m_values.find(identifier->name);
		if (it == m_values.end())
			return false;
		return isSSAWithDependencies(it->second);
	}
	else
		solAssert(std::holds_alternative<Literal>(*_expression), "Impossible expression type");

	return true;
}

std::set<YulName> SSAValueTracker::ssaVariables(Block const& _ast)
{
	SSAValueTracker t;
	t(_ast);
	std::set<YulName> ssaVars;
	for (auto const& value: t.values())
		ssaVars.insert(value.first);
	return ssaVars;
}

void SSAValueTracker::setValue(YulName _name, Expression const* _value)
{
	assertThrow(
		m_values.count(_name) == 0,
		OptimizerException,
		"Source needs to be disambiguated."
	);
	if (!_value)
		_value = &m_zero;
	m_values[_name] = _value;
}
